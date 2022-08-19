import "scripts/home/buttons/button"
import "scripts/garden/gardenScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GardenButton').extends(Button)

function GardenButton:init(x, y, foodList, petList)
    local buttonImageTable = gfx.imagetable.new("images/mainScreen/buttons/gardenButton-table-44-43")
    GardenButton.super.init(self, x, y, foodList, petList, buttonImageTable)
end

function GardenButton:pressButton()
    SceneManager:switchScene(GardenScene)
end