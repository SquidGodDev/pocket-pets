import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Mimic').extends(BaseEnemy)

function Mimic:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/mimic")
    Mimic.super.init(self, battleScene, enemyImage)
    self.maxHealth = 80
    self.health = self.maxHealth
    self.moveTime = 1500
    self.attackDmg = 5
end

function Mimic:attack()
    Mimic.super.attack(self)
    self:directRowAttack(self.attackDmg)
end