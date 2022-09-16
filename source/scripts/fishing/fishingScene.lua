-- The simple fishing mini-game scene. This was hacked together pretty quickly, so it's a bit messy.
-- The code structure is somewhat similar to my other fishing game

import "scripts/fishing/fishingPet"
import "scripts/home/homeScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('FishingScene').extends(gfx.sprite)

function FishingScene:init()
    local fishingBackground = gfx.image.new("images/fishing/fishingBackground")
    self:setImage(fishingBackground)
    self:moveTo(200, 120)
    self:add()

    local waterBackground = gfx.image.new("images/fishing/water")
    local waterSprite = gfx.sprite.new(waterBackground)
    local waterSpriteBaseY = 170
    waterSprite:moveTo(200, waterSpriteBaseY)
    waterSprite:add()
    local waterSpriteTimer = pd.timer.new(10000, 0, 8 * math.pi)
    waterSpriteTimer.repeats = true
    waterSpriteTimer.updateCallback = function(timer)
        waterSprite:moveTo(waterSprite.x, waterSpriteBaseY + 5 * math.sin(timer.value / 4))
    end

    local backPromptImage = gfx.image.new(150, 30)
    gfx.pushContext(backPromptImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(0, 0, 150, 30, 3)
        gfx.drawText("Ⓑ to return home", 5, (30 - 16) / 2)
    gfx.popContext()
    local backPromptSprite = gfx.sprite.new(backPromptImage)
    backPromptSprite:setCenter(0, 0)
    backPromptSprite:moveTo(10, 10)
    backPromptSprite:add()

    local dockBackground = gfx.image.new("images/fishing/dock")
    local dockSprite = gfx.sprite.new(dockBackground)
    dockSprite:moveTo(200, 222)
    dockSprite:add()

    FishingPet(68, 200)

    self.fishingRodX = 250
    self.fishingRodY = 75
    self.fishingRodSprite = gfx.sprite.new()
    self.fishingRodSprite:setCenter(0, 0)
    self.fishingRodSprite:moveTo(self.fishingRodX, self.fishingRodY)
    self.fishingRodSprite:add()
    self:createRodAnimator()

    self.fishingLineSprite = gfx.sprite.new()
    self.fishingLineSprite:setCenter(0, 0)
    self.fishingLineSprite:moveTo(self.fishingRodX + 26 - 42, self.fishingRodY + 11 - 51)
    self.fishingLineSprite:add()
    self:createLineAnimator()

    self.canCast = true

    self.rodEndX = self.fishingRodX + 26
    self.rodEndY = self.fishingRodY + 11
    self.lineStartX = self.rodEndX - 38
    self.lineStartY = self.rodEndY + 44
    self.lineEndY = self.lineStartY + 65
    self.curLineX = self.lineStartX
    self.curLineY = self.lineStartY

    self.reelLineSprite = gfx.sprite.new()
    self.reelLineSprite:setCenter(0, 0)
    self.reelLineSprite:moveTo(self.lineStartX, self.rodEndY)
    self.reeling = false

    local bobberImage = gfx.image.new("images/fishing/bobber")
    self.bobberSprite = gfx.sprite.new(bobberImage)
    self.bobberSprite:setZIndex(10)
    self.bobberYOffset = 0

    self.biteTimer = nil
    self.minBiteTime = 5000
    self.maxBiteTime = 15000

    self.fishCaught = false

    self.fishCountBackground = gfx.image.new("images/fishing/fishCounter")
    self.fishCountSprite = gfx.sprite.new()
    self.fishCountSprite:setCenter(0, 0)
    self.fishCountSprite:moveTo(320, 10)
    self.fishCountSprite:add()
    self.fishCount = 0
    self:drawFishCount()

    local fishImage = gfx.image.new("images/fishing/fish")
    self.fishSprite = gfx.sprite.new(fishImage)
    self.fishSprite:setCenter(0, 0)
    self.fishSpriteBaseY = 10 + 6
    self.fishSpriteBaseX = 320 + 5
    self.fishSprite:moveTo(self.fishSpriteBaseX, self.fishSpriteBaseY)
    self.fishSprite:add()

    self.showResults = false

    self.resultsSprite = gfx.sprite.new()
    self.resultsSprite:setZIndex(1000)
    self.resultsSpriteBaseY = -40
    self.resultsSprite:moveTo(200, self.resultsSpriteBaseY)
    self.resultsSprite:add()
    self.gemMultiplier = 2

    self.reelSound = pd.sound.sampleplayer.new("sound/fishing/Reel")
    self.reelInSound = pd.sound.sampleplayer.new("sound/fishing/ReelIn")
    self.scribbleSound = pd.sound.sampleplayer.new("sound/fishing/Scribble")
    self.splashSound = pd.sound.sampleplayer.new("sound/fishing/Splash")
    self.fishCatchSound = pd.sound.sampleplayer.new("sound/fishing/FishCatch")
end

-- For the state management, I basically am just checking if animators have finished or not.
-- I don't think that's really the best approach - it'd probably be better if I had explicit
-- states like with the battle scene.
function FishingScene:update()
    if pd.buttonJustPressed(pd.kButtonB) and not self.showResults then
        self.showResults = true
        self.resultsAnimator = gfx.animator.new(1000, self.resultsSpriteBaseY, 120, pd.easingFunctions.inOutCubic)
        GEMS += self.fishCount * self.gemMultiplier
        self:drawResults()
        self.scribbleSound:play()
    end

    if self.showResults then
        if self.resultsAnimator then
            self.resultsSprite:moveTo(self.resultsSprite.x, self.resultsAnimator:currentValue())
            if self.resultsAnimator:ended() then
                self.resultsAnimator = nil
            end
        else
            if pd.buttonJustPressed(pd.kButtonA) or pd.buttonJustPressed(pd.kButtonB) then
                SceneManager:switchScene(HomeScene)
            end
        end
        return
    end
    if pd.buttonJustPressed(pd.kButtonA) and self.canCast then
        self.canCast = false
        self.fishingRodAnimation.paused = false
    end

    if not self.fishingRodAnimation.paused then
        self.fishingRodSprite:setImage(self.fishingRodAnimation:image())
        if self.fishingRodAnimation.frame == self.fishingRodAnimation.endFrame then
            self.fishingRodAnimation.paused = true
            self.fishingRodAnimation.frame = 1
            self.fishingLineAnimation.paused = false
            self.fishingLineSprite:add()
            self.reelSound:play()
            self.splashSound:playAt(pd.sound.getCurrentTime() + .8)
        end
    end

    if not self.fishingLineAnimation.paused then
        self.fishingLineSprite:setImage(self.fishingLineAnimation:image())
        if self.fishingLineAnimation.frame == self.fishingLineAnimation.endFrame then
            self.fishingLineSprite:remove()
            self.fishingLineAnimation.paused = true
            self.fishingLineAnimation.frame = 1
            self.curLineX = self.lineStartX
            self.curLineY = self.lineStartY
            self.reelLineSprite:add()
            self:drawReelLine()
            self.reeling = true
            self.bobberSprite:add()
            self.bobberSprite:moveTo(self.lineStartX, self.lineStartY)
            self.biteTimer = pd.timer.new(math.random(self.minBiteTime, self.maxBiteTime), function()
                self.biteTimer = nil
                local bobAnimateTimer = pd.timer.new(500, 0, math.pi)
                bobAnimateTimer.updateCallback = function(timer)
                    self.bobberYOffset = math.floor(5 * math.sin(timer.value))
                    self.bobberSprite:moveTo(self.curLineX, self.curLineY + self.bobberYOffset)
                end
                bobAnimateTimer.timerEndedCallback = function()
                    self.fishCaught = true
                    self.splashSound:play()
                end
            end)
        end
    end

    if self.reeling then
        local crankTick = pd.getCrankTicks(6)
        if crankTick ~= 0 then
            if not self.reelInSound:isPlaying() then
                self.reelInSound:play(0)
            end
            self.curLineY += 1
            self:drawReelLine()
            self.bobberSprite:moveTo(self.curLineX, self.curLineY + self.bobberYOffset)
            if self.curLineY >= self.lineEndY then
                if self.biteTimer then
                    self.biteTimer:remove()
                end
                self.reeling = false
                local startPoint = pd.geometry.point.new(self.lineStartX, self.lineEndY)
                local endPoint = pd.geometry.point.new(self.rodEndX - 1, self.rodEndY + 1)
                self.reelInAnimator = gfx.animator.new(1000, startPoint, endPoint, pd.easingFunctions.inCubic)
            end
        else
            self.reelInSound:stop()
        end
    end

    if self.reelInAnimator then
        local curLinePoint = self.reelInAnimator:currentValue()
        self.curLineX = curLinePoint.x
        self.curLineY = curLinePoint.y
        self:drawReelLine()
        self.bobberSprite:moveTo(self.curLineX, self.curLineY + self.bobberYOffset)
        if self.reelInAnimator:ended() then
            self.reelInSound:stop()
            self.reelLineSprite:remove()
            self.canCast = true
            self.reelInAnimator = nil
            self.bobberSprite:remove()
            self:createRodAnimator()
            self:createLineAnimator()
            if self.fishCaught then
                self.fishCatchSound:play()
                self.fishCaught = false
                self:reeledInFish()
            end
        end
    end
end

function FishingScene:drawReelLine()
    local lineSpriteWidth = self.rodEndX - self.lineStartX
    local lineSpriteHeight = self.curLineY - self.rodEndY
    local lineImage = gfx.image.new(lineSpriteWidth, lineSpriteHeight)
    gfx.pushContext(lineImage)
        gfx.drawLine(self.rodEndX - self.lineStartX, 0, self.curLineX - self.lineStartX, self.curLineY - self.rodEndY)
    gfx.popContext()
    self.reelLineSprite:setImage(lineImage)
end

function FishingScene:drawFishCount()
    local fishCountBackground = self.fishCountBackground:copy()
    gfx.pushContext(fishCountBackground)
        gfx.drawText(self.fishCount, 26, 4)
    gfx.popContext()
    self.fishCountSprite:setImage(fishCountBackground)
end

function FishingScene:reeledInFish()
    self.fishCount += 1
    self:drawFishCount()
    local fishAnimateTimer = pd.timer.new(500, 0, math.pi)
    fishAnimateTimer.updateCallback = function(timer)
        self.fishSprite:moveTo(self.fishSprite.x, self.fishSpriteBaseY - 3 * math.sin(timer.value))
    end
    fishAnimateTimer.timerEndedCallback = function()
        self.fishSprite:moveTo(self.fishSpriteBaseX, self.fishSpriteBaseY)
    end
end

function FishingScene:createRodAnimator()
    local fishingRodImageTable = gfx.imagetable.new("images/fishing/fishingRod-table-150-170")
    self.fishingRodAnimation = gfx.animation.loop.new(70, fishingRodImageTable)
    self.fishingRodAnimation.paused = true
    self.fishingRodSprite:setImage(fishingRodImageTable[1])
end

function FishingScene:createLineAnimator()
    local fishingLineImageTable = gfx.imagetable.new("images/fishing/fishingLine-table-48-100")
    self.fishingLineAnimation = gfx.animation.loop.new(100, fishingLineImageTable)
    self.fishingLineAnimation.paused = true
    self.fishingLineSprite:setImage(fishingLineImageTable[1])
end

function FishingScene:drawResults()
    local resultsImage = gfx.image.new(80, 80)
    gfx.pushContext(resultsImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(0, 0, 80, 80, 4)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawRoundRect(0, 0, 80, 80, 4)
        local fishImage = gfx.image.new("images/fishing/fish")
        fishImage:draw(15, 17)
        gfx.drawText("x" .. self.fishCount, 35, 15)
        local gemImage = gfx.image.new("images/shop/gem")
        gemImage:draw(15, 55)
        gfx.drawText("x" .. self.fishCount * self.gemMultiplier, 35, 53)
    gfx.popContext()
    self.resultsSprite:setImage(resultsImage)
end