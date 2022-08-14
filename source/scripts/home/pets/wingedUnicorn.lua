import "scripts/home/pets/pet"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('WingedUnicorn').extends(Pet)

function WingedUnicorn:init(x, y)
    local petImageTable = gfx.imagetable.new("images/pets/wingedUnicorn-table-32-32")
    WingedUnicorn.super.init(self, x, y, petImageTable)
end