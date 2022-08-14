import "scripts/home/sky/clouds"
import "scripts/home/sky/sun"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Sky').extends(gfx.sprite)

function Sky:init()
    if not IS_DAYTIME() then
        local nightBackground = gfx.image.new("images/mainScreen/night")
        self:setImage(nightBackground)
    end
    self:moveTo(200, 120)
    self:add()
    Sun(356, 25)
    Clouds()
end