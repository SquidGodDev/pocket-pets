import "scripts/home/pets/pet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Crab').extends(Pet)

function Crab:init(x, y)
    local petImageTable = gfx.imagetable.new("images/pets/crab-table-32-32")
    Crab.super.init(self, x, y, petImageTable)
end