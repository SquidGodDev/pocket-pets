
local pd <const> = playdate
local gfx <const> = playdate.graphics

class('SceneManager').extends()

function SceneManager:init()
    self.transitionWidth = 400
    self.transitionTime = 600
    self.transitioningIn = false
end

function SceneManager:switchScene(scene, ...)
    if self.transitioningIn then
        return
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