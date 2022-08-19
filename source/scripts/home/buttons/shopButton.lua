import "scripts/home/buttons/button"
import "scripts/shop/shopScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('ShopButton').extends(Button)

function ShopButton:init(x, y, foodList, petList)
    local buttonImageTable = gfx.imagetable.new("images/mainScreen/buttons/shopButton-table-44-43")
    ShopButton.super.init(self, x, y, foodList, petList, buttonImageTable)
end

function ShopButton:pressButton()
    SceneManager:switchScene(ShopScene)
end