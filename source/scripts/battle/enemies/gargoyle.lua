import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Gargoyle').extends(BaseEnemy)

function Gargoyle:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/gargoyle")
    Gargoyle.super.init(self, battleScene, enemyImage)
    self.maxHealth = 180
    self.health = self.maxHealth
    self.moveTime = 1000
    self.attackDmg = 15
end

function Gargoyle:attack()
    Gargoyle.super.attack(self)
    self:directRowAttack(self.attackDmg)
end