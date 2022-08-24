import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Mandrake').extends(BaseEnemy)

function Mandrake:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/mandrake")
    Mandrake.super.init(self, battleScene, enemyImage)
    self.maxHealth = 80
    self.health = self.maxHealth
    self.moveTime = 1000
    self.attackDmg = 10
end

function Mandrake:attack()
    Mandrake.super.attack(self)
    self:directDoubleAttack(self.attackDmg)
end