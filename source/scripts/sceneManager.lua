import "scripts/home/homeScene"
import "scripts/battle/battleScene"

local pd <const> = playdate
local gfx <const> = playdate.graphics

class('SceneManager').extends()

function SceneManager:init()
    self.transitionWidth = 400
    self.transitionTime = 500
    self.transitioningIn = false
    self.transitionSound = pd.sound.sampleplayer.new("sound/UI/transitionWhoosh")
end

function SceneManager:switchScene(scene, ...)
    if self.transitioningIn then
        return
    end
    if scene == HomeScene then
        self.transitionSound:play()
        local menuItems = pd.getSystemMenu():getMenuItems()
        local musicOn = menuItems[1]:getValue()
        if musicOn then
            if not BgMusic:isPlaying() then
                BgMusic:play(0)
            end
        end
    elseif scene == BattleScene then
        BgMusic:stop()
    end
    self.transitionAnimator = gfx.animator.new(self.transitionTime, 0, self.transitionWidth, pd.easingFunctions.inOutCubic)
    self.transitioningIn = true

    self.newScene = scene
    self.sceneArgs = ...
    self:createTransitionSprite(false)
end

function SceneManager:loadNewScene()
    gfx.sprite.removeAll()
    self:removeAllTimers()
    gfx.setDrawOffset(0, 0)
    Signals:clear()
    self:createTransitionSprite(true)
    self.transitionAnimator = gfx.animator.new(self.transitionTime, self.transitionWidth, 0, pd.easingFunctions.inOutCubic)
    self.transitioningIn = false
    self.newScene(self.sceneArgs)
end

function SceneManager:update()
    if self.transitionAnimator then
        local transitionValue = self.transitionAnimator:currentValue()
        local transitionImage = gfx.image.new(self.transitionWidth, 240)
        gfx.pushContext(transitionImage)
            if self.transitioningIn then
                gfx.fillRect(0, 0, transitionValue, 240)
            else
                gfx.fillRect(self.transitionWidth - transitionValue, 0, transitionValue, 240)
            end
        gfx.popContext()
        self.transitionSprite:setImage(transitionImage)

        self.transitionAnimator:ended()
        if self.transitioningIn and self.transitionAnimator:ended() then
            gfx.clear(gfx.kColorBlack)
            self:loadNewScene()
        elseif self.transitionAnimator:ended() then
            self.transitionAnimator = nil
        end
    end
end

function SceneManager:createTransitionSprite(filled)
    self.transitionSprite = gfx.sprite.new(self.transitionWidth, 240)
    if filled then
        local filledImage = gfx.image.new(self.transitionWidth, 240, gfx.kColorBlack)
        self.transitionSprite:setImage(filledImage)
    end
    self.transitionSprite:setIgnoresDrawOffset(true)
    self.transitionSprite:setCenter(0, 0)
    self.transitionSprite:moveTo(0, 0)
    self.transitionSprite:setZIndex(10000)
    self.transitionSprite:add()
end

function SceneManager:removeAllTimers()
    local allTimers = pd.timer.allTimers()
    for index, timer in ipairs(allTimers) do
        timer:remove()
    end
end