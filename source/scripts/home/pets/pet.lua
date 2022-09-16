-- I used the AnimatedSprite library to create a simple state machine to handle the pet walking around
-- and animating. I also have a bunch of code for handling the emojis and stuff, but honestly it's such
-- a big mess and not architected very well

import "scripts/libraries/AnimatedSprite"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Pet').extends(AnimatedSprite)

function Pet:init(x, y, foodList)
    local petImagetable = GET_PET_IMAGETABLE(SELECTED_PET)
    Pet.super.init(self, petImagetable)
    self.foodList = foodList

    self:addState("idle", 1, 2, {tickStep = 8})
    self:addState("walk", 3, 4, {tickStep = 8})

    self.walkDirection = 1

    self.velocity = 0
    self.moveSpeed = 2

    self.minX = 0
    self.maxX = 400
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

    self.sadEmoji = gfx.image.new("images/mainScreen/emojis/sadEmoji")
    self.sadEmojiSprite = gfx.sprite.new(self.sadEmoji)
    self.sadEmojiSprite:setVisible(false)
    self.sadEmojiSprite:add()

    self.emojiTime = 2000
    self.emojiTimer = nil
    self.heartEmoji = gfx.image.new("images/mainScreen/emojis/heartEmoji")
    self.happyEmojiSprite = gfx.sprite.new(self.heartEmoji)
    self.happyEmojiSprite:setVisible(false)
    self.happyEmojiSprite:add()

    self.pettingImageTable = gfx.imagetable.new("images/mainScreen/emojis/hand-table-32-32")
    self.pettingAnimation = gfx.animation.loop.new(100, self.pettingImageTable, true)
    self.pettingSprite = gfx.sprite.new()
    self.pettingSprite:setVisible(false)
    self.pettingSprite:add()
    self.petting = false

    Signals:subscribe("happy", self, function()
        self:happy()
    end)

    Signals:subscribe("sad", self, function(_, _, flag)
        self:sad(flag)
    end)

    self.pettingSound = pd.sound.sampleplayer.new("sound/home/brushing")
end

function Pet:update()
    self:moveBy(self.velocity, 0)
    self:updateAnimation()
    self.happyEmojiSprite:moveTo(self.x, self.y - 24)
    self.sadEmojiSprite:moveTo(self.x, self.y - 24)

    if self.emojiTimer then
        self.happyEmojiSprite:setVisible(true)
    else
        self.happyEmojiSprite:setVisible(false)
    end

    local _, accelCrankChange = pd.getCrankChange()
    if math.abs(accelCrankChange) > 0 then
        if not self.pettingSound:isPlaying() and not self.foodList.listOut then
            self.pettingSound:play()
        end
        self.petting = true
        PETS[SELECTED_PET].lastPet = pd.getSecondsSinceEpoch()
        Signals:notify("updateStatDisplay")
    else
        self.petting = false
        self.pettingSound:stop()
    end

    if self.petting and not self.foodList.listOut then
        self.pettingSprite:setVisible(true)
        self.pettingSprite:moveTo(self.x + 10, self.y - 10)
        self.pettingSprite:setImage(self.pettingAnimation:image())
        self.happyEmojiSprite:setVisible(true)
    else
        self.pettingSprite:setVisible(false)
    end

    if self.currentState == "walk" then
        if self.x <= self.minX + self.edgeBuffer or self.x >= self.maxX - self.edgeBuffer then
            self:stopTimers()
            self:setWaitTimer()
        end
    end
end

function Pet:happy()
    if self.emojiTimer then
        self.emojiTimer:remove()
    end
    self.emojiTimer = pd.timer.new(self.emojiTime, function()
        self.emojiTimer = nil
    end)
end

function Pet:sad(flag)
    self.sadEmojiSprite:setVisible(flag)
end

function Pet:setWaitTimer()
    self:changeState("idle")
    self.velocity = 0
    self.waitTimer = pd.timer.new(math.random(self.waitTimeMin, self.waitTimeMax), function()
        self:setWalkTimer()
    end)
end

function Pet:setWalkTimer()
    if self.x <= self.minX + self.edgeBuffer then
        self.walkDirection = 1
    elseif self.x >= self.maxX - self.edgeBuffer then
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

function Pet:stopTimers()
    if self.walkTimer then
        self.walkTimer:remove()
    end
    if self.waitTimer then
        self.waitTimer:remove()
    end
end
