import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Kraken').extends(BaseEnemy)

function Kraken:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/kraken")
    Kraken.super.init(self, battleScene, enemyImage)
    self.maxHealth = 150
    self.health = self.maxHealth
    self.moveTime = 1000
    self.attackDmg = 15
end

function Kraken:attack()
    Kraken.super.attack(self)
    self:xAttack(self.attackDmg)
end