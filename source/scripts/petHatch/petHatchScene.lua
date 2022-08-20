
local pd <const> = playdate
local gfx <const> = pd.graphics

class('PetHatchScene').extends(gfx.sprite)

function PetHatchScene:init()
    self.backgroundImage = gfx.image.new("images/petHatch/petHatchBackground")
    self:moveTo(200, 120)
    self:setImage(self.backgroundImage)
    self:add()

    self.inputBoxPadding = 0
    self.inputBoxWidth = 12 * 12 + self.inputBoxPadding * 2
    self.inputBoxHeight = 30
    self.inputBoxImage = gfx.image.new(self.inputBoxWidth, self.inputBoxHeight)
    gfx.pushContext(self.inputBoxImage)
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(0, 0, self.inputBoxWidth, self.inputBoxHeight, 3)
        gfx.setColor(gfx.kColorBlack)
        gfx.drawRoundRect(0, 0, self.inputBoxWidth, self.inputBoxHeight, 3)
    gfx.popContext()
    self.inputBox = gfx.sprite.new(self.inputBoxImage)
    self.inputBoxStartY = -20
    self.inputBoxEndY = 120
    self.inputBox:moveTo(120, self.inputBoxStartY)
    self.inputBox:add()
    self.inputBoxAnimator = nil
    self.addedInputBox = false

    self.showKeyboard = false
    pd.keyboard.keyboardDidHideCallback = function(flag)
        self.showKeyboard = false
        if not flag then
            pd.keyboard.text = ""
            self.inputBoxAnimator = gfx.animator.new(200, self.inputBox.y, self.inputBoxStartY, pd.easingFunctions.inOutCubic)
        end
    end

    pd.keyboard.textChangedCallback = function()
        if #pd.keyboard.text > 8 then
            pd.keyboard.text = string.sub(pd.keyboard.text, 1, 8)
        end
        local inputBoxTextImage = self.inputBoxImage:copy()
        gfx.pushContext(inputBoxTextImage)
            gfx.drawTextAligned(pd.keyboard.text, self.inputBoxWidth / 2, (self.inputBoxHeight - 16) / 2, kTextAlignment.center)
        gfx.popContext()
        self.inputBox:setImage(inputBoxTextImage)
    end
end

function PetHatchScene:update()
    if self.showKeyboard then
        pd.keyboard.show()
    elseif pd.buttonJustPressed(pd.kButtonA) then
        self.showKeyboard = true
        self.inputBoxAnimator = gfx.animator.new(200, self.inputBox.y, self.inputBoxEndY, pd.easingFunctions.inOutCubic)
    end

    if self.inputBoxAnimator then
        self.inputBox:moveTo(self.inputBox.x, self.inputBoxAnimator:currentValue())
        if self.inputBoxAnimator:ended() then
            self.inputBoxAnimator = nil
        end
    end
end