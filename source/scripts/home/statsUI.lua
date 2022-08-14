
local pd <const> = playdate
local gfx <const> = pd.graphics

class('StatsUI').extends(gfx.sprite)

function StatsUI:init(x, y)
    local statusUIBackground = gfx.image.new("images/mainScreen/statusUI")
    self:setImage(statusUIBackground)
    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
end

function StatsUI:update()
    
end

