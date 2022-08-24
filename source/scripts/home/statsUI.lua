
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
    self.hungerCounterTime = 432 -- Decrease hunger by 100 in 12 hours
    self.updateCounter = 0

    self:initializeStats()
    self:updateHunger(0)

    Signals:subscribe("feed", self, function(_, _, amount)
        self:feed(amount)
    end)

    Signals:subscribe("updateStatDisplay", self, function()
        self:updateStatsDisplay()
    end)
end

function StatsUI:update()
    if self.updateCounter % (self.hungerCounterTime * 20) == 0 then
        self:updateHunger(-1)
    end
    self.updateCounter += 1
end

function StatsUI:initializeStats()
    local petStats = PETS[SELECTED_PET]
    self.hunger = petStats.hunger.level
    local secondsFromNow = pd.epochFromTime(pd.getTime())
    local secondsFromThen = pd.epochFromTime(petStats.hunger.lastTime)
    local hungerDiff = math.ceil((secondsFromNow - secondsFromThen) / self.hungerCounterTime)
    self.hunger -= hungerDiff
    if self.hunger <= 0 then
        self.hunger = 0
    end
    PETS[SELECTED_PET].hunger.level = self.hunger

    self:calculatePetHappiness()

    self.level = petStats.level
    self.xp = petStats.xp
end

function StatsUI:calculatePetHappiness()
    local petStats = PETS[SELECTED_PET]

    local secondsFromNow = pd.epochFromTime(pd.getTime())
    local secondsSinceLastPet = pd.epochFromTime(petStats.lastPet)
    local petMultiplier = 1 - (secondsFromNow - secondsSinceLastPet) / self.petTimeRate
    if petMultiplier <= 0 then
        petMultiplier = 0
    end

    local secondsSinceLastGame = pd.epochFromTime(petStats.lastGamePlay)
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
        gfx.fillRect(25, 25, (self.happiness / 100) * meterWidth, meterHeight)
        gfx.fillRect(25, 48, (self.hunger / 100) * meterWidth, meterHeight)
    gfx.popContext()
    self:setImage(statDisplayImage)
end

function StatsUI:updateHunger(change)
    self.hunger += change
    if self.hunger <= 0 then
        self.hunger = 0
    elseif self.hunger >= 100 then
        self.hunger = 100
    end
    PETS[SELECTED_PET].hunger.lastTime = pd.getTime()
    PETS[SELECTED_PET].hunger.level = self.hunger

    if self.hunger <= 20 then
        Signals:notify("sad", true)
    else
        Signals:notify("sad", false)
    end

    self:calculatePetHappiness()
    self:updateStatsDisplay()
end

function StatsUI:feed(amount)
    self:updateHunger(amount)
end