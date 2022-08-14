import "scripts/home/pets/pet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Chicken').extends(Pet)

function Chicken:init(x, y)
    local petImageTable = gfx.imagetable.new("images/pets/chicken-table-32-32")
    Chicken.super.init(self, x, y, petImageTable)
end