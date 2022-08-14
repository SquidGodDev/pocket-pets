import "scripts/home/pets/pet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('BuffBunny').extends(Pet)

function BuffBunny:init(x, y)
    local petImageTable = gfx.imagetable.new("images/pets/buffBunny-table-32-32")
    BuffBunny.super.init(self, x, y, petImageTable)
end