import "scripts/home/pets/pet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Bat').extends(Pet)

function Bat:init(x, y)
    local petImageTable = gfx.imagetable.new("images/pets/bat-table-32-32")
    Bat.super.init(self, x, y, petImageTable)
end