import "scripts/home/buttons/button"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('FeedButton').extends(Button)

function FeedButton:init(x, y, foodList, petList)
    local buttonImageTable = gfx.imagetable.new("images/mainScreen/buttons/feedButton-table-44-43")
    FeedButton.super.init(self, x, y, foodList, petList, buttonImageTable)
end

function FeedButton:pressButton()
    Signals:notify("openFoodList")
end