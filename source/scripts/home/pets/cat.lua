import "scripts/home/pets/pet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Cat').extends(Pet)

function Cat:init(x, y)
    local petImageTable = gfx.imagetable.new("images/pets/cat-table-32-32")
    Cat.super.init(self, x, y, petImageTable)
end