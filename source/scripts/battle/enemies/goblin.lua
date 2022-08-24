import "scripts/battle/enemies/baseEnemy"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Goblin').extends(BaseEnemy)

function Goblin:init(battleScene)
    local enemyImage = gfx.image.new("images/battle/enemies/goblin")
    Goblin.super.init(self, battleScene, enemyImage)
    self.maxHealth = 50
    self.health = self.maxHealth
    self.moveTime = 800
    self.attackDmg = 5
end

function Goblin:attack()
    Goblin.super.attack(self)
    self:directSingleAttack(self.attackDmg)
end