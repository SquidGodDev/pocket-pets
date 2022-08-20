--[[
Written by Nic Magnier: https://devforum.play.date/t/a-list-of-helpful-libraries-and-code/221/15

class to create simple animations using easing as building blocks

To create a simple sequence:
	animation = sequence.new():from(0):to(1,2.0,"soft-out"):mirror()

	currentValue = animation:get()

]]--

-- TODO
--	:callback(fn,...)

sequence = {}
sequence.__index = sequence

-- private member
local _easings = playdate.easingFunctions
if not _easings then
	print("sequence warning: easing function not found. Don't forget to call import 'CoreLibs/easing'")
	return
end

local _runningSequences = table.create(32,0)
local _previousUpdateTime = playdate.getCurrentTimeMilliseconds()

-- create a new sequence

function sequence.new()
	local new_sequence = {
		time = 0,
		duration = 0,
		loop = false,
		lastEasingIndex = 0,
		easings = table.create(4, 0),

		cachedResultTimestamp = nil,
		cachedResult = 0,
		previousUpdateEasingIndex = nil
	}

	return setmetatable(new_sequence, sequence)
end

function sequence.update()
	local currentTime = playdate.getCurrentTimeMilliseconds()
	local deltaTime = (currentTime-_previousUpdateTime) / 1000
	_previousUpdateTime = currentTime

	for index = #_runningSequences, 1, -1 do
		local seq = _runningSequences[index]

		seq.time = seq.time + deltaTime
		seq.cachedResultTimestamp = nil

		if seq:isDone() then
			table.remove(_runningSequences, index)
		end
	end
end

function sequence.print()
	print("Sequences running:", #_runningSequences)
end

function sequence:clear()
	self.time = 0
	self.duration = 0
	self.loop = false
	self.lastEasingIndex = 0
	self.cachedResultTimestamp = nil
	self.cachedResult = 0
	self.previousUpdateEasingIndex = nil

	if self.timer then
		self.timer:remove()
		self.timer = nil
	end
end

-- Reinitialize the sequence
function sequence:from( from )
	from = from or 0

	-- release all easings
	self:clear()

	-- setup first empty easing at the beginning of the sequence
	local newEasing = self:newEasing()
	newEasing.timestamp = 0
	newEasing.from = from
	newEasing.to = from
	newEasing.duration = 0
	newEasing.fn = _easings.flat

	return self
end

function sequence:to( to, duration, easingFunction, ... )
	if not self then return end

	-- default parameters
	to = to or 0
	duration = duration or 0
	easingFunction = easingFunction or _easing.inOutQuad
	if type(easingFunction)=="string" then
		easingFunction = _easings[easingFunction] or _easing.inOutQuad
	end

	local lastEasing = self.easings[self.lastEasingIndex]
	local newEasing = self:newEasing()

	-- setup first empty easing at the beginning of the sequence
	newEasing.timestamp = lastEasing.timestamp + lastEasing.duration
	newEasing.from = lastEasing.to
	newEasing.to = to
	newEasing.duration = duration
	newEasing.fn = easingFunction
	newEasing.params = {...}

	-- update overall sequence infos
	self.duration = self.duration + duration

	return self
end

function sequence:set( value )
	if not self then return end

	local lastEasing = self.easings[self.lastEasingIndex]
	local newEasing = self:newEasing()

	-- setup first empty easing at the beginning of the sequence
	newEasing.timestamp = lastEasing.timestamp + lastEasing.duration
	newEasing.from = value
	newEasing.to = value
	newEasing.duration = 0
	newEasing.fn = _easings.flat

	return self
end

-- @repeatCount: number of times the last easing as to be duplicated
-- @mirror: bool, does the repeating easings have to be mirrored (yoyo effect)
function sequence:again( repeatCount, mirror )
	if not self then return end
	
	repeatCount = repeatCount or 1

	local previousEasing = self.easings[self.lastEasingIndex]

	for i = 1, number do
		local newEasing = self:newEasing()

		-- setup first empty easing at the beginning of the sequence
		newEasing.timestamp = previousEasing.timestamp + previousEasing.duration
		newEasing.duration = previousEasing.duration
		newEasing.fn = previousEasing.fn
		newEasing.params = previousEasing.params

		if mirror then
			newEasing.from = previousEasing.to
			newEasing.to = previousEasing.from
		else
			newEasing.from = previousEasing.from
			newEasing.to = previousEasing.to
		end

		-- update overall sequence infos
		self.duration = self.duration + newEasing.duration

		previousEasing = newEasing
	end

	return self
end

function sequence:sleep( duration )
	if not self then return end

	duration = duration or 0
	if duration==0 then
		return self
	end

	local lastEasing = self.easings[self.lastEasingIndex]
	local new_easing = self:newEasing()

	-- setup first empty easing at the beginning of the sequence
	new_easing.timestamp = lastEasing.timestamp + lastEasing.duration
	new_easing.from = lastEasing.to
	new_easing.to = lastEasing.to
	new_easing.duration = duration
	new_easing.fn = _easings.flat

	-- update overall sequence infos
	self.duration = self.duration + duration

	return self
end

function sequence:loop()
	self.loop = "loop"
	return self
end

function sequence:mirror()
	self.loop = "mirror"
	return self
end

function sequence:newEasing()
	self.lastEasingIndex = self.lastEasingIndex + 1
	return self:getEasingByIndex(self.lastEasingIndex)
end

function sequence:getEasingByIndex( index )
	if self.easings[index] then
		return self.easings[index]
	end

	local new_easing = {
		timestamp = 0,
		from = 0,
		to = 0,
		duration = 0,
		params = nil,
		fn = _easings.flat
	}

	self.easings[index] = new_easing

	return new_easing
end

function sequence:getEasingByTime( clampedTime )
	if self:isEmpty() then
		print("sequence warning: empty animation")
		return nil
	end

	local easingIndex = self.previousUpdateEasingIndex or 1

	while easingIndex>=1 and easingIndex<=self.lastEasingIndex do
		local easing = self.easings[easingIndex]

		if clampedTime < easing.timestamp then
			easingIndex = easingIndex - 1
		elseif clampedTime > (easing.timestamp+easing.duration) then
			easingIndex = easingIndex + 1
		else
			self.previousUpdateEasingIndex = easingIndex
			return easing, easingIndex
		end
	end

	-- we didn't the correct part
	print("sequence warning: couldn't find sequence part. clampedTime probably out of bound.", clampedTime, self.duration)
	return self.easings[1]
end

function sequence:get( time )
	if not self then return nil end

	if self:isEmpty() then
		return 0
	end

	time = time or self.time

	-- try to get cached result
	if self.cachedResultTimestamp==time then
		return self.cachedResult
	end

	-- we calculate and cache the result
	local clampedTime = self:getClampedTime(time)
	local easing = self:getEasingByTime(clampedTime)
	local result = easing.fn(clampedTime-easing.timestamp, easing.from, easing.to-easing.from, easing.duration, table.unpack(easing.params or {}))

	-- cache
	self.cachedResultTimestamp = clampedTime
	self.cachedResult = result

	return result
end

-- get the time clamped in the sequence duration
-- manage time using loop setting
function sequence:getClampedTime( time )
	time = time or self.time

	-- time is looped
	if self.loop=="loop" then
		return time%self.duration

	-- time is mirrored / yoyo
	elseif self.loop=="mirror" then
		time = time%(self.duration*2)
		if time>self.duration then
			time = self.duration + self.duration - time
		end

		return time
	end

	-- time is normally clamped
	return math.clamp(time, 0, self.duration)
end

function sequence:start()
	table.insert(_runningSequences, self)
	return self
end

function sequence:stop()
	table.remove(_runningSequences, table.indexOfElement(self))
	self.time = 0
	self.cachedResultTimestamp = nil
	return self
end

function sequence:pause()
	table.remove(_runningSequences, table.indexOfElement(self))
	return self
end

function sequence:restart()
	self.time = 0
	self.cachedResultTimestamp = nil
	self:start()
	return self
end

function sequence:isDone()
    return self.time>=self.duration and (not self.loop)
end

function sequence:isEmpty()
    return self.lastEasingIndex==0
end

-- new easing function
function _easings.flat(t, b, c, d)
	return b
end

math.clamp = math.clamp or function(a, min, max)
	if min > max then
		min, max = max, min
	end
	return math.max(min, math.min(max, a))
end


