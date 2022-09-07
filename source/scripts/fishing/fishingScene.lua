
local pd <const> = playdate
local gfx <const> = playdate.graphics

class('FishingScene').extends(gfx.sprite)

function FishingScene:init()
    local fishingBackground = gfx.image.new("images/fishing/fishingBackground")
    self:setImage(fishingBackground)
    self:moveTo(200, 120)
    self:add()

    local fishingRodImageTable = gfx.imagetable.new("images/fishing/fishingRod-table-150-170")
    self.fishingRodAnimation = gfx.animation.loop.new(70, fishingRodImageTable)
    self.fishingRodAnimation.paused = true
    self.fishingRodSprite = gfx.sprite.new(fishingRodImageTable[1])
    self.fishingRodSprite:setCenter(0, 0)
    self.fishingRodX = 250
    self.fishingRodY = 75
    self.fishingRodSprite:moveTo(self.fishingRodX, self.fishingRodY)
    self.fishingRodSprite:add()

    local fishingLineImageTable = gfx.imagetable.new("images/fishing/fishingLine-table-48-100")
    self.fishingLineAnimation = gfx.animation.loop.new(100, fishingLineImageTable)
    self.fishingLineAnimation.paused = true
    self.fishingLineSprite = gfx.sprite.new(fishingLineImageTable[1])
    self.fishingLineSprite:setCenter(0, 0)
    self.fishingLineSprite:moveTo(self.fishingRodX + 26 - 42, self.fishingRodY + 11 - 51)
    self.fishingLineSprite:add()

    self.canCast = true

    self.rodEndX = self.fishingRodX + 26
    self.rodEndY = self.fishingRodY + 11
    self.lineStartX = self.rodEndX - 40
    self.lineStartY = self.rodEndY + 50
    self.lineEndY = self.lineStartY + 65
    self.curLineX = self.lineStartX
    self.curLineY = self.lineStartY

    self.reelLineSprite = gfx.sprite.new()
    self.reelLineSprite:setCenter(0, 0)
    self.reelLineSprite:moveTo(self.lineStartX, self.rodEndY)
    self.reeling = false
end

function FishingScene:update()
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
            self.reeling = true
            self.reelLineSprite:add()
            self:drawReelLine()
        end
    end

    if self.reeling then
        local crankTick = pd.getCrankTicks(6)
        if crankTick ~= 0 then
            self.curLineY += 1
            self:drawReelLine()
            if self.curLineY >= self.lineEndY then
                self.reeling = false
                local startPoint = pd.geometry.point.new(self.lineStartX, self.lineEndY)
                local endPoint = pd.geometry.point.new(self.rodEndX - 1, self.rodEndY + 1)
                self.reelInAnimator = gfx.animator.new(1000, startPoint, endPoint, pd.easingFunctions.inCubic)
            end
        end
    end

    if self.reelInAnimator then
        local curLinePoint = self.reelInAnimator:currentValue()
        self.curLineX = curLinePoint.x
        self.curLineY = curLinePoint.y
        self:drawReelLine()
        if self.reelInAnimator:ended() then
            self.reelLineSprite:remove()
            self.canCast = true
            self.reelInAnimator = nil
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