
local pd <const> = playdate
local gfx <const> = pd.graphics

class('StatsUI').extends(gfx.sprite)

function StatsUI:init(x, y)
    self.statusUIBackground = gfx.image.new("images/mainScreen/statusUI")
    self:setImage(self.statusUIBackground)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()

    self.petHappinessBase = 10
    self.gameHappinessBase = 20
    self.hungerHappinessBase = 70

    self.petTimeRate = 86400 -- 24 Hours
    self.gameTimeRate = 86400 -- 24 Hours
    self.hungerTimerRate = 43200 -- 12 Hours
    self.updateCounter = 0

    self:initializeStats()

    Signals:subscribe("feed", self, function(_, _, amount)
        self:feed(amount)
    end)

    Signals:subscribe("updateStatDisplay", self, function()
        self:calculatePetHappiness()
        self:updateStatsDisplay()
    end)

    self.sadSound = pd.sound.sampleplayer.new("sound/home/whimper")
    self.sadRepeat = true
end

function StatsUI:update()
    if self.updateCounter % 20 == 0 then
        self:updateHunger()
    end
    self.updateCounter += 1

    if self.hunger <= 20 then
        if self.sadRepeat then
            self.sadRepeat = false
            self.sadSound:play()
            pd.timer.new(10000, function()
                self.sadRepeat = true
            end)
        end
    end
end

function StatsUI:initializeStats()
    local petStats = PETS[SELECTED_PET]
    self:updateHunger()
    self:calculatePetHappiness()

    self.level = petStats.level
    self.xp = petStats.xp
end

function StatsUI:calculatePetHappiness()
    local petStats = PETS[SELECTED_PET]

    local secondsFromNow = pd.getSecondsSinceEpoch()
    local secondsSinceLastPet = petStats.lastPet
    local petMultiplier = 1 - (secondsFromNow - secondsSinceLastPet) / self.petTimeRate
    if petMultiplier <= 0 then
        petMultiplier = 0
    end

    local secondsSinceLastGame = petStats.lastGamePlay
    local gameMultiplier = 1 - (secondsFromNow - secondsSinceLastGame) / self.gameTimeRate
    if gameMultiplier <= 0 then
        gameMultiplier = 0
    end

    local hungerMultiplier = self.hunger / 100

    self.happiness = math.ceil(self.petHappinessBase * petMultiplier + self.gameHappinessBase * gameMultiplier + self.hungerHappinessBase * hungerMultiplier)
end

function StatsUI:updateStatsDisplay()
    local statDisplayImage = self.statusUIBackground:copy()
    gfx.pushContext(statDisplayImage)
        gfx.drawText("*Name: *" .. SELECTED_PET, 6, 3)
        local meterWidth = 96
        local meterHeight = 13
        gfx.fillRect(26, 25, math.ceil(self.happiness / 100 * meterWidth), meterHeight)
        gfx.fillRect(26, 48, math.ceil(self.hunger / 100 * meterWidth), meterHeight)
        local curLevel = PETS[SELECTED_PET].level
        local levelText = tostring(curLevel)
        local xpRequired = math.floor((curLevel + 2)^3 - (curLevel + 1) ^ 3) + 1
        local curXp = math.floor(PETS[SELECTED_PET].xp - (curLevel + 1) ^ 3) + 1
        local xpText = "XP: " .. curXp .. "/" .. xpRequired
        gfx.drawText(levelText, 27, 70)
        gfx.drawText(xpText, 55, 70)
    gfx.popContext()
    self:setImage(statDisplayImage)
end

function StatsUI:updateHunger()
    self.hunger = self:calculateHunger()

    if self.hunger <= 20 then
        Signals:notify("sad", true)
    else
        Signals:notify("sad", false)
    end

    self:calculatePetHappiness()
    self:updateStatsDisplay()
end

function StatsUI:feed(amount)
    local calculatedHunger = self:calculateHunger()
    local newHunger = calculatedHunger + amount
    if newHunger <= 0 then
        newHunger = 0
    elseif newHunger >= 100 then
        newHunger = 100
    end
    PETS[SELECTED_PET].hunger.lastTime = pd.getSecondsSinceEpoch()
    PETS[SELECTED_PET].hunger.level = newHunger
    self.hunger = newHunger
    self:updateHunger()
end

function StatsUI:calculateHunger()
    local petFedTime = PETS[SELECTED_PET].hunger.lastTime
    local petHungerBaseLevel = PETS[SELECTED_PET].hunger.level
    local secondsFromNow = pd.getSecondsSinceEpoch()
    local calculatedHunger = petHungerBaseLevel - math.floor((secondsFromNow - petFedTime) / self.hungerTimerRate * 100)
    if calculatedHunger <= 0 then
        calculatedHunger = 0
    elseif calculatedHunger >= 100 then
        calculatedHunger = 100
    end

    return calculatedHunger
end