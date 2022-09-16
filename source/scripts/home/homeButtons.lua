-- So this is a super scrappy button system that I set up. It's honestly not very good - I should've
-- made it more extensible and generic, but how it is right now is it's extremely rigid and a pain
-- to add or remove buttons. I made it this way since I wanted the click animation, but that could've
-- been done way better and easier...

import "scripts/home/buttons/feedButton"
import "scripts/home/buttons/gardenButton"
import "scripts/home/buttons/shopButton"
import "scripts/home/buttons/battleButton"
import "scripts/home/buttons/starButton"
import "scripts/home/buttons/petButton"

local pd <const> = playdate
local gfx <const> = pd.graphics

SELECTED_HOME_BUTTON = 3

class('HomeButtons').extends(gfx.sprite)

function HomeButtons:init(foodList, petList)
    self.buttonBaseX, self.buttonBaseY = 42, 208
    self.buttonXGap = 64
    self.homeButtons = {}
    table.insert(self.homeButtons, FeedButton(self.buttonBaseX, self.buttonBaseY, foodList, petList))
    table.insert(self.homeButtons, GardenButton(self.buttonBaseX + self.buttonXGap, self.buttonBaseY, foodList, petList))
    table.insert(self.homeButtons, ShopButton(self.buttonBaseX + self.buttonXGap * 2, self.buttonBaseY, foodList, petList))
    table.insert(self.homeButtons, BattleButton(self.buttonBaseX + self.buttonXGap * 3, self.buttonBaseY, foodList, petList))
    table.insert(self.homeButtons, StarButton(self.buttonBaseX + self.buttonXGap * 4, self.buttonBaseY, foodList, petList))
    table.insert(self.homeButtons, PetButton(self.buttonBaseX + self.buttonXGap * 5, self.buttonBaseY, foodList, petList))
    self.homeButtons[SELECTED_HOME_BUTTON]:select(true)

    self.spriteFlushed = false
    self.selectImage = gfx.image.new("images/mainScreen/buttons/selectBorder")
    self.selectSprite = gfx.sprite.new(self.selectImage)
    self.selectSprite:moveTo(self.buttonBaseX + (SELECTED_HOME_BUTTON - 1) * self.buttonXGap, self.buttonBaseY)
    self.selectSprite:add()

    self.clickSound = pd.sound.sampleplayer.new("sound/UI/mouseClick")

    self:add()
end

function HomeButtons:update()
    if pd.buttonJustPressed(pd.kButtonLeft) then
        self:moveCursorLeft()
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        self:moveCursorRight()
    end
end

function HomeButtons:moveCursorLeft()
    if SELECTED_HOME_BUTTON > 1 then
        self.clickSound:play()
        local selectedButton = self.homeButtons[SELECTED_HOME_BUTTON]
        selectedButton:select(false)
        SELECTED_HOME_BUTTON -= 1
        selectedButton = self.homeButtons[SELECTED_HOME_BUTTON]
        selectedButton:select(true)
        self:updateSelectCursor()
        self:clearCursor(1)
    end
end

function HomeButtons:moveCursorRight()
    if SELECTED_HOME_BUTTON < #self.homeButtons then
        self.clickSound:play()
        local selectedButton = self.homeButtons[SELECTED_HOME_BUTTON]
        selectedButton:select(false)
        SELECTED_HOME_BUTTON += 1
        selectedButton = self.homeButtons[SELECTED_HOME_BUTTON]
        selectedButton:select(true)
        self:updateSelectCursor()
        self:clearCursor(-1)
    end
end

function HomeButtons:updateSelectCursor()
    self.selectSprite:moveTo(self.buttonBaseX + (SELECTED_HOME_BUTTON - 1) * self.buttonXGap, self.buttonBaseY)
end

function HomeButtons:clearCursor(offset)
    if not self.spriteFlushed then
        self.spriteFlushed = true
        gfx.pushContext()
            gfx.setLineWidth(5)
            gfx.drawRect(self.buttonBaseX + (SELECTED_HOME_BUTTON + offset - 1) * self.buttonXGap - 27, 179, 56, 55)
        gfx.popContext()
    end
end