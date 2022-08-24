
local pd <const> = playdate
local gfx <const> = pd.graphics

class('WarningIcon').extends(gfx.sprite)

function WarningIcon:init(x, y)
    self.warningImageTable = gfx.imagetable.new("images/battle/warning-table-51-51")
    self.warningAnimation = gfx.animation.loop.new(300, self.warningImageTable, false)

    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:setZIndex(50)
    self:add()
end

function WarningIcon:update()
    self:setImage(self.warningAnimation:image())
    if not self.warningAnimation:isValid() then
        self:remove()
    end
end