
local pd <const> = playdate
local gfx <const> = pd.graphics

class('PlayerAttackSprite').extends(gfx.sprite)

function PlayerAttackSprite:init(x, y)
    self.playerAttackImagetable = gfx.imagetable.new("images/battle/playerAttack-table-42-36")
    self.attackAnimation = gfx.animation.loop.new(50, self.playerAttackImagetable, false)

    self:setCenter(0, 0)
    self:moveTo(x, y)
    self:add()
end

function PlayerAttackSprite:update()
    self:setImage(self.attackAnimation:image())
    if not self.attackAnimation:isValid() then
        self:remove()
    end
end