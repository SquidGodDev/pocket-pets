import "scripts/home/pets/pet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Snake').extends(Pet)

function Snake:init(x, y)
    local petImageTable = gfx.imagetable.new("images/pets/snake-table-36-32")
    Snake.super.init(self, x, y, petImageTable)
end