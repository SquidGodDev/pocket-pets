import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Wendigo').extends(BaseEnemy)

function Wendigo:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/wendigo")
    Wendigo.super.init(self, battleScene, enemyImage)
    self.maxHealth = 50
    self.health = self.maxHealth
    self.moveTime = 1500
    self.attackDmg = 10
end

function Wendigo:attack()
    Wendigo.super.attack(self)
    self:directSingleAttack(self.attackDmg)
end