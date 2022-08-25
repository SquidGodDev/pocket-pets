import "scripts/home/statsUI"
import "scripts/home/homeButtons"
import "scripts/home/food/foodList"
import "scripts/home/sky/sky"
import "scripts/home/pets/pet"

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
    HomeButtons(foodList)
    local selectedPetType = PETS[SELECTED_PET].type
    Pet(120, 159, selectedPetType, foodList)
end
