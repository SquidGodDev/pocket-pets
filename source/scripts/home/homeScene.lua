-- This is the main home screen that boots up when you launch the game. There's several moving parts to this, so it's
-- been split up among multiple files and sections. Here's the file structure:

--[[
    buttons/
        button.lua - The base button class to handle the buttons. Honestly, not a very good system...
                     I wouldn't do it this way if I did it again
    food/
        foodList.lua - Handles the list drawing for the food. It's basically the same as seedList.lua and gameList.lua
    games/
        gameList.lua - Handles the list for the available mini-games. It's basically the same as seedList.lua and foodList.lua
    pets/
        pet.lua - The base pet class that handles drawing the pet on the home screen and having them wander around. All the other
                  pet files aren't actually used at all, so they should've been deleted.
    sky/
        cloudBanner.lua - Old code that handled moving clouds. Not used anymore - should've deleted
        clouds.lau - Also not used and should've been deleted
        sky.lua - Just draws the night sky
        sun.lua - Just handles drawing the sun or moon depending on the time of day
    homeButtons.lua - Handles the buttons on the home scene
    homeScene.lua - This file
    statsUI.lua - Handles the pet stats on the top left
]]--

import "scripts/home/statsUI"
import "scripts/home/homeButtons"
import "scripts/home/food/foodList"
import "scripts/home/sky/sky"
import "scripts/home/pets/pet"
import "scripts/home/games/gameList"

import "scripts/manual/manualScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('HomeScene').extends(gfx.sprite)

function HomeScene:init()
    -- This is how I hacked together the evolution, since I had to make it backwards compatible with the
    -- save files in v1.0. I just check on the home screen what level your pet is, and make sure to evolve it.
    for pet, petData in pairs(PETS) do
        if petData.level > 15 and petData.petEvolution == nil then
            if petData.hunger.level >= 50 then
                petData.petEvolution = 1
            else
                petData.petEvolution = 2
            end
            PETS[pet] = petData
        end
    end
    Sky()
    local background = gfx.image.new("images/mainScreen/background")
    self:moveTo(200, 120)
    self:setImage(background)
    self:add()
    StatsUI(5, 5)
    local foodList = FoodList()
    local gameList = GameList()
    HomeButtons(foodList, gameList)
    Pet(120, 159, foodList)

    local menu = pd.getSystemMenu()
    menu:addMenuItem("How to Play", function()
        SceneManager:switchScene(ManualScene)
    end)
end
