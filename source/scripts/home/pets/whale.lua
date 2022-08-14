import "scripts/home/pets/pet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Whale').extends(Pet)

function Whale:init(x, y)
    local petImageTable = gfx.imagetable.new("images/pets/whale-table-32-32")
    Whale.super.init(self, x, y, petImageTable)
end