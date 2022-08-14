
local pd <const> = playdate
local gfx <const> = pd.graphics

class('CloudBanner').extends(gfx.sprite)

function CloudBanner:init(x)
    local cloudBannerImage = gfx.image.new("images/mainScreen/clouds/cloudBanner")
    self:setImage(cloudBannerImage)
    self:setCenter(1, 0.5)
    self:moveTo(x, 105)
    self:add()

    self.moveSpeed = .2
end

function CloudBanner:update()
    self:moveBy(self.moveSpeed, 0)
    if self.x >= 1200 then
        self:remove()
    end
end