import "scripts/home/buttons/button"
import "scripts/wish/wishScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('PetButton').extends(Button)

function PetButton:init(x, y)
    local buttonImageTable = gfx.imagetable.new("images/mainScreen/buttons/petButton-table-44-43")
    PetButton.super.init(self, x, y, buttonImageTable)
end

function PetButton:pressButton()

end