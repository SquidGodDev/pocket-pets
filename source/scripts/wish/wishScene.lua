-- This is the wish scene. It's pretty simple, just some animations and a little
-- bit of UI. I do check the time here, and see if you made your wish already.

import "scripts/home/homeScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('WishScene').extends(gfx.sprite)

function WishScene:init()
    self.wishImageTable = gfx.imagetable.new("images/wish/wishAnimation-table-400-240")
    self.wishAnimation = nil

    self:setImage(self.wishImageTable:getImage(1))
    self:moveTo(200, 120)
    self:add()

    self.wishButtonImageTable = gfx.imagetable.new("images/wish/wishBUtton-table-160-47")
    self.wishButtonSprite = gfx.sprite.new(self.wishButtonImageTable:getImage(1))
    self.wishButtonSprite:setCenter(0, 0)
    self.wishButtonSprite:moveTo(113, 180)
    self.wishButtonSprite:add()

    self.rewardSprite = gfx.sprite.new()
    self.rewardSprite:moveTo(200, 80)
    self.rewardSprite:add()

    self.rewardSpriteAnimator = nil

    -- This is how I check if you're on a new day or not
    local curTime = pd.getTime()
    if curTime.year ~= WISH_GRANT_TIME.year or curTime.month ~= WISH_GRANT_TIME.month or curTime.day ~= WISH_GRANT_TIME.day then
        WISH_GRANTED = false
    end

    if WISH_GRANTED then
        self.wishButtonSprite:remove()
        self.noWishSprite = gfx.sprite.new()
        self.noWishSprite:moveTo(200, 180)
        local textPadding = 20
        local noWishText = "The stars sparkle. Come back tomorrow!"
        local textWidth, textHeight = gfx.getTextSize(noWishText)
        local noWishWidth = textWidth + textPadding * 2
        local noWishHeight = 35
        local noWishImage = gfx.image.new(noWishWidth, noWishHeight)
        gfx.pushContext(noWishImage)
            gfx.setColor(gfx.kColorWhite)
            gfx.fillRoundRect(0, 0, noWishWidth, noWishHeight, 4)
            gfx.setColor(gfx.kColorBlack)
            gfx.drawRoundRect(0, 0, noWishWidth, noWishHeight, 4)
            gfx.drawText(noWishText, textPadding, (noWishHeight - textHeight) / 2)
        gfx.popContext()
        self.noWishSprite:setImage(noWishImage)
        self.noWishSprite:add()
    end

    self.sparkleSound = pd.sound.sampleplayer.new("sound/wish/sparkle")
    self.jingleSound = pd.sound.sampleplayer.new("sound/wish/jingle")
    self.jingleSound:play()
end

function WishScene:update()
    if pd.buttonJustPressed(pd.kButtonA) and not WISH_GRANTED then
        self.sparkleSound:play()
        WISH_GRANTED = true
        local curTime = pd.getTime()
        WISH_GRANT_TIME = {
            year = curTime.year,
            month = curTime.month,
            day = curTime.day
        }
        self:playAnimation()
        self:createRewardImage()
    end

    if pd.buttonIsPressed(pd.kButtonA) then
        self.wishButtonSprite:setImage(self.wishButtonImageTable:getImage(2))
    else
        self.wishButtonSprite:setImage(self.wishButtonImageTable:getImage(1))
    end

    if pd.buttonJustPressed(pd.kButtonB) then
        SceneManager:switchScene(HomeScene)
    end

    if self.wishAnimation then
        self:setImage(self.wishAnimation:image())
    end

    if self.rewardSpriteAnimator then
        local fadedRewardImage = gfx.image.new(self.rewardImage:getSize())
        gfx.pushContext(fadedRewardImage)
            self.rewardImage:drawFaded(0, 0, self.rewardSpriteAnimator:currentValue(), gfx.image.kDitherTypeBayer8x8)
        gfx.popContext()
        self.rewardSprite:setImage(fadedRewardImage)
        if self.rewardSpriteAnimator:ended() then
            self.rewardSpriteAnimator = nil
        end
    end
end

function WishScene:playAnimation()
    self.wishAnimation = gfx.animation.loop.new(100, self.wishImageTable, false)
end

function WishScene:getRandomReward()
    local isGemReward = math.random(2)
    if isGemReward == 1 then
        self.gemReward = true
        self.rewardAmount = math.random(10, 40)
        GEMS += self.rewardAmount
    else
        self.gemReward = false
        self.rewardAmount = math.random(2, 6)
        self.rewardSeed = PLANTS_IN_ORDER[math.random(1, #PLANTS_IN_ORDER)]
        PLANT_INVENTORY[self.rewardSeed].seeds += self.rewardAmount
    end
end

function WishScene:createRewardImage()
    local imagePadding = 20
    local imageHeight = 35
    local iconPadding = 6
    local iconWidth = 16
    self:getRandomReward()
    if self.gemReward then
        local rewardText = "The stars grant you *" .. self.rewardAmount .. "*"
        local textWidth, textHeight = gfx.getTextSize(rewardText)
        local rewardImageWidth = imagePadding * 2 + iconWidth + iconPadding + textWidth
        local rewardImage = gfx.image.new(rewardImageWidth, imageHeight)
        gfx.pushContext(rewardImage)
            gfx.setColor(gfx.kColorWhite)
            gfx.fillRoundRect(0, 0, rewardImageWidth, imageHeight, 4)
            gfx.setColor(gfx.kColorBlack)
            gfx.drawRoundRect(0, 0, rewardImageWidth, imageHeight, 4)
            gfx.drawText(rewardText, imagePadding, (imageHeight - textHeight) / 2)
            local gemImage = gfx.image.new("images/shop/gem")
            gemImage:drawAnchored(imagePadding + textWidth + iconPadding, imageHeight / 2 - 2, 0.0, 0.5)
        gfx.popContext()
        self.rewardImage = rewardImage
    else
        local rewardText1 = "The stars grant you *" .. self.rewardAmount .. "*"
        local rewardText2 = "seeds"
        local textWidth1, textHeight = gfx.getTextSize(rewardText1)
        local textWidth2 = gfx.getTextSize(rewardText2)
        local rewardImageWidth = imagePadding * 2 + iconWidth + iconPadding * 2 + textWidth1 + textWidth2
        local rewardImage = gfx.image.new(rewardImageWidth, imageHeight)
        gfx.pushContext(rewardImage)
            gfx.setColor(gfx.kColorWhite)
            gfx.fillRoundRect(0, 0, rewardImageWidth, imageHeight, 4)
            gfx.setColor(gfx.kColorBlack)
            gfx.drawRoundRect(0, 0, rewardImageWidth, imageHeight, 4)
            gfx.drawText(rewardText1, imagePadding, (imageHeight - textHeight) / 2)
            gfx.drawText(rewardText2, imagePadding + textWidth1 + iconPadding * 2 + iconWidth, (imageHeight - textHeight) / 2)
            gfx.setImageDrawMode(gfx.kDrawModeInverted)
            local plantImage = gfx.image.new("images/garden/plants/"..self.rewardSeed)
            plantImage:drawAnchored(imagePadding + textWidth1 + iconPadding, imageHeight / 2 - 2, 0.0, 0.5)
        gfx.popContext()
        self.rewardImage = rewardImage
    end
    self.rewardSpriteAnimator = gfx.animator.new(1000, 0.0, 1.0, pd.easingFunctions.inOutCubic)
end

-- Show prompt when wish is already granted
-- B to go back home