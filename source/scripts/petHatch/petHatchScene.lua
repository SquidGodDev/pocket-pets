import "scripts/libraries/Sequence"
import "scripts/home/homeScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('PetHatchScene').extends(gfx.sprite)

function PetHatchScene:init()
    -- self.backgroundImage = gfx.image.new("images/petHatch/petHatchBackground")
    -- self:moveTo(200, 120)
    -- self:setImage(self.backgroundImage)
    self:add()

    local fullEggImage = gfx.image.new("images/petHatch/fullEgg")
    self.fullEggSprite = gfx.sprite.new(fullEggImage)
    self.baseEggX = 200
    self.baseEggY = 120
    self.fullEggSprite:moveTo(self.baseEggX, self.baseEggY)
    self.fullEggSprite:add()
    self.eggShakeOffset = 10
    self.eggShakeTime = 0.1
    self.crankCount = 0
    self.shakeAnimationFinished = false

    self.animationFinished = false

    self.petImageSprite = gfx.sprite.new()
    self.petImageSprite:moveTo(self.baseEggX, self.baseEggY - 10)
    local bottomEggImage = gfx.image.new("images/petHatch/eggBottomHalf")
    self.bottomEggSprite = gfx.sprite.new(bottomEggImage)
    self.bottomEggSprite:moveTo(self.baseEggX, self.baseEggY)
    local topEggImage = gfx.image.new("images/petHatch/eggTopHalf")
    self.topEggSprite = gfx.sprite.new(topEggImage)
    self.topEggSprite:moveTo(self.baseEggX, self.baseEggY)

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
    self.inputBox:setZIndex(1000)
    self.inputBox:add()
    self.inputBoxAnimator = nil

    self.showKeyboard = false
    pd.keyboard.keyboardDidHideCallback = function()
        self.showKeyboard = false
    end

    pd.keyboard.keyboardWillHideCallback = function(flag)
        -- self.inputBoxAnimator = gfx.animator.new(200, self.inputBox.y, self.inputBoxStartY, pd.easingFunctions.inOutCubic)
        if not flag then
            pd.keyboard.text = ""
            self.whooshSound:play()
        else
            local keyboardText = pd.keyboard.text
            if PETS[keyboardText] then
                self:showToast("Name already used", 2000, 120, 150)
                self.whooshSound:play()
            else
                self.acceptSound:play()
                self:createNewPet(keyboardText)
                SceneManager:switchScene(HomeScene)
            end
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

    self.petType = PET_TYPES[math.random(1, #PET_TYPES)]

    self.eggShakeSound = pd.sound.sampleplayer.new("sound/petHatch/eggShake")
    self.whooshSound = pd.sound.sampleplayer.new("sound/petHatch/whoosh")
    self.acceptSound = pd.sound.sampleplayer.new("sound/petHatch/accept")
end

function PetHatchScene:update()
    sequence.update()

    if not self.shakeAnimationFinished then
        local crankTicks = pd.getCrankTicks(1)
        if crankTicks ~= 0 then
            self.crankCount += 1
            if self.crankCount == 1 then
                self.eggShakeSound:play()
                self.fullEggSequence = sequence.new():from(self.baseEggX):to(self.baseEggX - self.eggShakeOffset, self.eggShakeTime, "linear"):to(self.baseEggX, self.eggShakeTime, "linear")
                self.fullEggSequence:start()
            elseif self.crankCount == 2 then
                self.eggShakeSound:play()
                self.fullEggSequence = sequence.new():from(self.baseEggX):to(self.baseEggX + self.eggShakeOffset, self.eggShakeTime, "linear"):to(self.baseEggX, self.eggShakeTime, "linear")
                self.fullEggSequence:start()
            elseif self.crankCount == 3 then
                self.eggShakeSound:play()
                self.fullEggSequence = sequence.new():from(self.baseEggX):to(self.baseEggX - self.eggShakeOffset, self.eggShakeTime, "linear"):to(self.baseEggX, self.eggShakeTime, "linear")
                self.fullEggSequence:start()
            elseif self.crankCount == 4 then
                self.eggShakeSound:play()
                self.shakeAnimationFinished = true
                self.fullEggSprite:remove()
                local petImageTable = gfx.imagetable.new("images/pets/"..self.petType.."-table-32-32")
                local petImage = petImageTable:getImage(1)
                self.petImageSprite:setImage(petImage)
                self.petImageSprite:add()
                self.bottomEggSprite:add()
                self.topEggSprite:add()
            end
        end
    end

    if self.crankCount >= 1 and self.crankCount <= 3 then
        self.fullEggSprite:moveTo(self.fullEggSequence:get(), self.fullEggSprite.y)
    end

    if self.shakeAnimationFinished and not self.animationFinished then
        local crankChange = pd.getCrankChange()
        self.topEggSprite:moveBy(0, -math.abs(crankChange / 20))
        if self.topEggSprite.y < 50 then
            self.whooshSound:play()
            self.animationFinished = true
            self.showKeyboard = true
            self.inputBoxAnimator = gfx.animator.new(200, self.inputBox.y, self.inputBoxEndY, pd.easingFunctions.inOutCubic)
        end
    end

    if self.showKeyboard then
        pd.keyboard.show()
    elseif pd.buttonJustPressed(pd.kButtonA) and self.animationFinished then
        self.showKeyboard = true
        self.whooshSound:play()
    end

    if self.inputBoxAnimator then
        self.inputBox:moveTo(self.inputBox.x, self.inputBoxAnimator:currentValue())
        if self.inputBoxAnimator:ended() then
            self.inputBoxAnimator = nil
        end
    end
end

function PetHatchScene:createNewPet(name)
    SELECTED_PET = name
    local petData = {
        type = self.petType,
        hunger = {
            level = 50,
            lastTime = playdate.getTime()
        },
        lastPet = playdate.getTime(),
        lastGamePlay = playdate.getTime(),
        level = 0,
        xp = 0,
        plantDeck = {}
    }
    PETS[name] = petData
end

function PetHatchScene:showToast(text, duration, x, y)
    local t = pd.timer.new(duration)
    local textWidth, textHeight = gfx.getTextSize(text)
    local textPadding = 6
    textWidth += textPadding
    textHeight += textPadding

    local toastSprite = gfx.sprite.new()
    toastSprite:moveTo(x, y)
    toastSprite:add()

    local toastImage = gfx.image.new(textWidth, textHeight)
    gfx.pushContext(toastImage)
        gfx.setColor(gfx.kColorBlack)
        gfx.fillRoundRect(0, 0, textWidth, textHeight, 3)
        gfx.setImageDrawMode(gfx.kDrawModeInverted)
        gfx.drawTextAligned(text, textWidth / 2, (textHeight - 16) / 2, kTextAlignment.center)
    gfx.popContext()
    toastSprite:setImage(toastImage)

    print("HERE!!")

    t.timerEndedCallback = function()
        print("TIMER ENDED!")
        toastSprite:remove()
    end
end