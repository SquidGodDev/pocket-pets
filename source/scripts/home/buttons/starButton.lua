import "scripts/home/buttons/button"
import "scripts/wish/wishScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('StarButton').extends(Button)

function StarButton:init(x, y)
    local buttonImageTable = gfx.imagetable.new("images/mainScreen/buttons/starButton-table-44-43")
    StarButton.super.init(self, x, y, buttonImageTable)
end

function StarButton:pressButton()
    SceneManager:switchScene(WishScene)
end