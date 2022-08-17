import "scripts/home/buttons/feedButton"
import "scripts/home/buttons/gardenButton"
import "scripts/home/buttons/shopButton"
import "scripts/home/buttons/battleButton"
import "scripts/home/buttons/starButton"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('HomeButtons').extends(gfx.sprite)

function HomeButtons:init()
    self.buttonBaseX, self.buttonBaseY = 71, 208
    self.buttonXGap = 64
    self.homeButtons = {}
    self.selectedHomeButton = 1
    table.insert(self.homeButtons, FeedButton(self.buttonBaseX, self.buttonBaseY))
    table.insert(self.homeButtons, GardenButton(self.buttonBaseX + self.buttonXGap, self.buttonBaseY))
    table.insert(self.homeButtons, ShopButton(self.buttonBaseX + self.buttonXGap * 2, self.buttonBaseY))
    table.insert(self.homeButtons, BattleButton(self.buttonBaseX + self.buttonXGap * 3, self.buttonBaseY))
    table.insert(self.homeButtons, StarButton(self.buttonBaseX + self.buttonXGap * 4, self.buttonBaseY))
    self.homeButtons[1]:select(true)

    self.selectImage = gfx.image.new("images/mainScreen/buttons/selectBorder")
    self.selectSprite = gfx.sprite.new(self.selectImage)
    self.selectSprite:moveTo(self.buttonBaseX, self.buttonBaseY)
    self.selectSprite:add()

    self:add()
end

function HomeButtons:update()
    if pd.buttonJustPressed(pd.kButtonLeft) then
        self:moveCursorLeft()
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        self:moveCursorRight()
    end

    local crankTick = pd.getCrankTicks(3)
    if crankTick == 1 then
        self:moveCursorRight()
    elseif crankTick == -1 then
        self:moveCursorLeft()
    end
end

function HomeButtons:moveCursorLeft()
    if self.selectedHomeButton > 1 then
        local selectedButton = self.homeButtons[self.selectedHomeButton]
        selectedButton:select(false)
        self.selectedHomeButton -= 1
        selectedButton = self.homeButtons[self.selectedHomeButton]
        selectedButton:select(true)
        self:updateSelectCursor()
    end
end

function HomeButtons:moveCursorRight()
    if self.selectedHomeButton < #self.homeButtons then
        local selectedButton = self.homeButtons[self.selectedHomeButton]
        selectedButton:select(false)
        self.selectedHomeButton += 1
        selectedButton = self.homeButtons[self.selectedHomeButton]
        selectedButton:select(true)
        self:updateSelectCursor()
    end
end

function HomeButtons:updateSelectCursor()
    self.selectSprite:moveTo(self.buttonBaseX + (self.selectedHomeButton - 1) * self.buttonXGap, self.buttonBaseY)
end