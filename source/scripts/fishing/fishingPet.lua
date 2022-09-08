import "scripts/libraries/AnimatedSprite"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('FishingPet').extends(AnimatedSprite)

function FishingPet:init(x, y, type)
    local petImagetable = gfx.imagetable.new("images/pets/" .. type .. "-table-32-32")
    FishingPet.super.init(self, petImagetable)
    self.foodList = foodList

    self:addState("idle", 1, 2, {tickStep = 8})
    self:addState("walk", 3, 4, {tickStep = 8})

    self.walkDirection = 1

    self.velocity = 0
    self.moveSpeed = 1

    self.minX = 25
    self.maxX = 180
    self.edgeBuffer = 20

    self.walkTimeMin = 1000
    self.walkTimeMax = 3000

    self.waitTimeMin = 1000
    self.waitTimeMax = 5000

    self.waitTimer = pd.timer.new(math.random(self.waitTimeMin, self.waitTimeMax), function()
        self:setWalkTimer()
    end)
    self.walkTimer = nil

    self:playAnimation()
    self:moveTo(x, y)
end

function FishingPet:update()
    self:moveBy(self.velocity, 0)
    self:updateAnimation()

    if self.currentState == "walk" then
        if self.x <= self.minX or self.x >= self.maxX then
            self:stopTimers()
            self:setWaitTimer()
        end
    end
end

function FishingPet:setWaitTimer()
    self:changeState("idle")
    self.velocity = 0
    self.waitTimer = pd.timer.new(math.random(self.waitTimeMin, self.waitTimeMax), function()
        self:setWalkTimer()
    end)
end

function FishingPet:setWalkTimer()
    if self.x <= self.minX then
        self.walkDirection = 1
    elseif self.x >= self.maxX then
        self.walkDirection = -1
    else
        local randNum = math.random(2)
        if randNum == 1 then
            self.walkDirection = 1
        else
            self.walkDirection = -1
        end
    end
    self.velocity = self.moveSpeed * self.walkDirection
    if self.velocity < 0 then
        self.globalFlip = 1
    elseif self.velocity > 0 then
        self.globalFlip = 0
    end

    self:changeState("walk")
    self.walkTimer = pd.timer.new(math.random(self.walkTimeMin, self.walkTimeMax), function()
        self:setWaitTimer()
    end)
end

function FishingPet:stopTimers()
    if self.walkTimer then
        self.walkTimer:remove()
    end
    if self.waitTimer then
        self.waitTimer:remove()
    end
end
