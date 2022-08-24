import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Mermaid').extends(BaseEnemy)

function Mermaid:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/mermaid")
    Mermaid.super.init(self, battleScene, enemyImage)
    self.maxHealth = 80
    self.health = self.maxHealth
    self.moveTime = 800
    self.attackDmg = 5
end

function Mermaid:attack()
    Mermaid.super.attack(self)
    self:directRowAttack(self.attackDmg)
end