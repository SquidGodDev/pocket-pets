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
