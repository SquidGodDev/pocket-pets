import "scripts/home/buttons/button"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('BattleButton').extends(Button)

function BattleButton:init(x, y, foodList, petList)
    local buttonImageTable = gfx.imagetable.new("images/mainScreen/buttons/gameButton-table-44-43")
    BattleButton.super.init(self, x, y, foodList, petList, buttonImageTable)
end

function BattleButton:pressButton()
    
end