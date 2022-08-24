import "scripts/battle/playerAttackSprite"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('BaseEnemy').extends(gfx.sprite)

function BaseEnemy:init(battleScene, image)
    self.battleScene = battleScene

    self.maxHealth = 100
    self.health = 0

    self.moveTime = 2000
    self.attackBias = 0.5
    self.attackDmg = 5
    self.teleporter = false

    self.row = 2
    self.baseX = 321
    self.baseY = 73
    self.gap = 51
    self:setCenter(0, 0)
    self:moveTo(self.baseX + 100, self.baseY + self.gap)
    self:setImage(image)
    self:add()

    self.dead = false
end

function BaseEnemy:update()
    if self.deathAnimator then
        self:moveTo(self.x, self.deathAnimator:currentValue())
        if self.deathAnimator:ended() then
            self:remove()
        end
    elseif self.attackAnimator then
        self:moveTo(self.attackAnimator:currentValue())
        if self.attackAnimator:ended() then
            self.attackAnimator = nil
        end
    end
end

function BaseEnemy:createMoveTimer()
    self.moveTimer = pd.timer.new(self.moveTime, function()
        local randVal = math.random()
        if randVal >= self.attackBias then
            self:attack()
        else
            self:move()
        end
        self:createMoveTimer()
    end)
end

function BaseEnemy:damage(dmg)
    self.health -= dmg
    if self.health <= 0 then
        self.dead = true
        self.health = 0
        if self.moveTimer then
            self.moveTimer:remove()
        end
        self.deathAnimator = gfx.animator.new(1000, self.y, 260, pd.easingFunctions.inBack)
    end
    self:setVisible(false)
    pd.timer.new(100, function()
        self:setVisible(true)
    end)
end

function BaseEnemy:attack()
    local attackDist = 10
    local attackOutLine = pd.geometry.lineSegment.new(self.x, self.y, self.x - attackDist, self.y)
    local attackInLine = pd.geometry.lineSegment.new(self.x - attackDist, self.y, self.x, self.y)
    self.attackAnimator = gfx.animator.new({100, 100}, {attackOutLine, attackInLine}, {pd.easingFunctions.linear, pd.easingFunctions.linear})
    -- Extend
end

function BaseEnemy:move()
    local validMoves
    if self.row == 1 then
        if self.teleporter then
            validMoves = {2, 3}
        else
            validMoves = {2}
        end
    elseif self.row == 2 then
        validMoves = {1, 3}
    elseif self.row == 3 then
        if self.teleporter then
            validMoves = {1, 2}
        else
            validMoves = {2}
        end
    end
    self.row = validMoves[math.random(1, #validMoves)]
    self:moveTo(self.baseX, self.baseY + (self.row - 1) * self.gap)
end

function BaseEnemy:singleAttack(dmg, x, y)
    self.battleScene:createWarning(x, y)
    pd.timer.new(1200, function()
        if self.dead then
            return
        end
        self.battleScene:damagePlayer(dmg, x, y)
        local gridBaseX = self.battleScene.gridBaseX
        local gridBaseY = self.battleScene.gridBaseY
        local gridGap = self.battleScene.gridGap
        PlayerAttackSprite(gridBaseX + (x - 1) * (gridGap), gridBaseY + (y - 1) * (gridGap))
    end)
end

function BaseEnemy:directSingleAttack(dmg)
    local attackX = math.random(1, 3)
    local attackY = self.row
    self:singleAttack(dmg, attackX, attackY)
end

function BaseEnemy:directRowAttack(dmg)
    for i=1,3 do
        self:singleAttack(dmg, i, self.row)
    end
end

function BaseEnemy:directDoubleAttack(dmg)
    local attackY = self.row
    local attackPattern = math.random(3)
    if attackPattern == 1 then
        self:singleAttack(dmg, 1, attackY)
        self:singleAttack(dmg, 2, attackY)
    elseif attackPattern == 2 then
        self:singleAttack(dmg, 2, attackY)
        self:singleAttack(dmg, 3, attackY)
    else
        self:singleAttack(dmg, 1, attackY)
        self:singleAttack(dmg, 3, attackY)
    end
end

function BaseEnemy:xAttack(dmg)
    local xPattern = math.random(2)
    if xPattern == 1 then
        self:singleAttack(dmg, 1, 1)
        self:singleAttack(dmg, 3, 1)
        self:singleAttack(dmg, 2, 2)
        self:singleAttack(dmg, 1, 3)
        self:singleAttack(dmg, 3, 3)
    else
        self:singleAttack(dmg, 2, 1)
        self:singleAttack(dmg, 1, 2)
        self:singleAttack(dmg, 2, 2)
        self:singleAttack(dmg, 3, 2)
        self:singleAttack(dmg, 2, 3)
    end
end

function BaseEnemy:columnAttack(dmg)
    local colPattern = math.random(2)
    if colPattern == 1 then
        self:singleAttack(dmg, 2, 1)
        self:singleAttack(dmg, 2, 2)
        self:singleAttack(dmg, 2, 3)
    else
        self:singleAttack(dmg, 1, 1)
        self:singleAttack(dmg, 1, 2)
        self:singleAttack(dmg, 1, 3)

        self:singleAttack(dmg, 3, 1)
        self:singleAttack(dmg, 3, 2)
        self:singleAttack(dmg, 3, 3)
    end
end