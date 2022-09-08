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
    Sky()
    local background = gfx.image.new("images/mainScreen/background")
    self:moveTo(200, 120)
    self:setImage(background)
    self:add()
    StatsUI(5, 5)
    local foodList = FoodList()
    local gameList = GameList()
    HomeButtons(foodList, gameList)
    local selectedPetType = PETS[SELECTED_PET].type
    Pet(120, 159, selectedPetType, foodList)

    local menu = pd.getSystemMenu()
    menu:addMenuItem("How to Play", function()
        SceneManager:switchScene(ManualScene)
    end)
end
