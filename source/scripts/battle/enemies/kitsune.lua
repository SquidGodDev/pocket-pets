import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Kitsune').extends(BaseEnemy)

function Kitsune:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/kitsune")
    Kitsune.super.init(self, battleScene, enemyImage)
    self.maxHealth = 100
    self.health = self.maxHealth
    self.moveTime = 1000
    self.attackDmg = 10
end

function Kitsune:attack()
    Kitsune.super.attack(self)
    self:columnAttack(self.attackDmg)
end