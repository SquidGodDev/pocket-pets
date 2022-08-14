import "scripts/home/buttons/button"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('ShopButton').extends(Button)

function ShopButton:init(x, y)
    local buttonImageTable = gfx.imagetable.new("images/mainScreen/buttons/shopButton-table-44-43")
    ShopButton.super.init(self, x, y, buttonImageTable)
end

function ShopButton:pressButton()
    
end