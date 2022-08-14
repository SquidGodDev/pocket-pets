import "scripts/home/buttons/button"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GardenButton').extends(Button)

function GardenButton:init(x, y)
    local buttonImageTable = gfx.imagetable.new("images/mainScreen/buttons/gardenButton-table-44-43")
    GardenButton.super.init(self, x, y, buttonImageTable)
end

function GardenButton:pressButton()
     
end