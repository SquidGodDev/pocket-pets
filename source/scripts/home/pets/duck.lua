import "scripts/home/pets/pet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Duck').extends(Pet)

function Duck:init(x, y)
    local petImageTable = gfx.imagetable.new("images/pets/duck-table-32-32")
    Duck.super.init(self, x, y, petImageTable)
end