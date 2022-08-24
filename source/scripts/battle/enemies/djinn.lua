import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Djinn').extends(BaseEnemy)

function Djinn:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/djinn")
    Djinn.super.init(self, battleScene, enemyImage)
    self.maxHealth = 150
    self.health = self.maxHealth
    self.moveTime = 400
    self.attackDmg = 15
end

function Djinn:attack()
    Djinn.super.attack(self)
    self:directDoubleAttack(self.attackDmg)
end