import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Cyclops').extends(BaseEnemy)

function Cyclops:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/cyclops")
    Cyclops.super.init(self, battleScene, enemyImage)
    self.maxHealth = 120
    self.health = self.maxHealth
    self.moveTime = 1500
    self.attackDmg = 20
end

function Cyclops:attack()
    Cyclops.super.attack(self)
    self:directSingleAttack(self.attackDmg)
end