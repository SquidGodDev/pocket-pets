import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Phoenix').extends(BaseEnemy)

function Phoenix:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/phoenix")
    Phoenix.super.init(self, battleScene, enemyImage)
    self.maxHealth = 100
    self.health = self.maxHealth
    self.moveTime = 500
    self.attackDmg = 10
end

function Phoenix:attack()
    Phoenix.super.attack(self)
    self:directRowAttack(self.attackDmg)
end