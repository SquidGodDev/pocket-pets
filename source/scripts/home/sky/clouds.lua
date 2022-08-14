import "scripts/home/sky/cloudBanner"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Clouds').extends(gfx.sprite)

function Clouds:init()
    -- self.curBanner = CloudBanner(400)
    local staticClouds = gfx.image.new("images/mainScreen/clouds/staticClouds")
    self:setImage(staticClouds)
    self:moveTo(200, 105)
    self:add(staticClouds)
end

function Clouds:update()
    -- if self.curBanner.x >= 800 then
    --     self.curBanner = CloudBanner(0)
    -- end
end
