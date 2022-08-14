import "scripts/home/pets/pet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Dog').extends(Pet)

function Dog:init(x, y)
    local petImageTable = gfx.imagetable.new("images/pets/dog-table-32-32")
    Dog.super.init(self, x, y, petImageTable)
end