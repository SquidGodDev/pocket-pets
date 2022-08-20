import "scripts/home/buttons/button"
import "scripts/petList/petListScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('PetButton').extends(Button)

function PetButton:init(x, y, foodList, petList)
    local buttonImageTable = gfx.imagetable.new("images/mainScreen/buttons/petButton-table-44-43")
    PetButton.super.init(self, x, y, foodList, petList, buttonImageTable)
end

function PetButton:pressButton()
    SceneManager:switchScene(PetListScene)
end