import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Dragon').extends(BaseEnemy)

function Dragon:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/dragon")
    Dragon.super.init(self, battleScene, enemyImage)
    self.maxHealth = 150
    self.health = self.maxHealth
    self.moveTime = 1000
    self.attackDmg = 15
end

function Dragon:attack()
    Dragon.super.attack(self)
    self:columnAttack(self.attackDmg)
end