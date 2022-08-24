import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Cerberus').extends(BaseEnemy)

function Cerberus:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/cerberus")
    Cerberus.super.init(self, battleScene, enemyImage)
    self.maxHealth = 100
    self.health = self.maxHealth
    self.moveTime = 1500
    self.attackDmg = 10
end

function Cerberus:attack()
    Cerberus.super.attack(self)
    self:xAttack(self.attackDmg)
end