import "scripts/home/homeScene"

import "scripts/battle/playerAttackSprite"
import "scripts/battle/warningIcon"
import "scripts/battle/enemies/goblin"
import "scripts/battle/enemies/wendigo"
import "scripts/battle/enemies/mimic"
import "scripts/battle/enemies/mermaid"
import "scripts/battle/enemies/cyclops"
import "scripts/battle/enemies/mandrake"
import "scripts/battle/enemies/kitsune"
import "scripts/battle/enemies/phoenix"
import "scripts/battle/enemies/cerberus"
import "scripts/battle/enemies/gargoyle"
import "scripts/battle/enemies/dragon"
import "scripts/battle/enemies/djinn"
import "scripts/battle/enemies/kraken"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('BattleScene').extends(gfx.sprite)

function BattleScene:init()
    self.plantImages = {}
    for i, plantType in ipairs(PLANTS_IN_ORDER) do
        local plantImage = gfx.image.new("images/garden/plants/" .. plantType)
        plantImage:setInverted(true)
        self.plantImages[plantType] = plantImage:scaledImage(2)
    end

    local battleBackground = gfx.image.new("images/battle/battleBackground")
    self:moveTo(200, 120)
    self:setImage(battleBackground)
    self:add()

    self.playerX = 2
    self.playerY = 2
    self.playerMaxHealth = 10 + PETS[SELECTED_PET].level * 5
    self.playerHealth = self.playerMaxHealth

    local petType = PETS[SELECTED_PET].type
    local petImageTable = gfx.imagetable.new("images/pets/"..petType.."-table-32-32")
    local petImage = petImageTable:getImage(1)
    self.playerSprite = gfx.sprite.new(petImage)
    self.playerSprite:setZIndex(100)
    self.gridBaseX = 91
    self.gridBaseY = 73
    self.gridGap = 51
    self.playerSprite:setCenter(0, 0)
    self.playerSprite:moveTo(self.gridBaseX + self.gridGap, self.gridBaseY + self.gridGap)
    self.playerSprite:add()

    self.enemyBaseX = 321
    self.enemyBaseY = 73
    self.enemyGap = 51

    self.enemyInstance = Cerberus(self)

    self.gardenGrid = {}
    for i=1,3 do
        self.gardenGrid[i] = {}
    end

    self.gardenSprites = {}
    for x=1,3 do
        self.gardenSprites[x] = {}
        for y=1,3 do
            local curGardenSprite = gfx.sprite.new()
            curGardenSprite:setCenter(0, 0)
            curGardenSprite:moveTo(self.gridBaseX + (x - 1) * self.gridGap, self.gridBaseY + (y - 1) * self.gridGap)
            curGardenSprite:add()
            self.gardenSprites[x][y] = curGardenSprite
        end
    end

    self.plantDeck = PETS[SELECTED_PET].plantDeck

    self.queueBaseX = 15
    self.queueBaseY = 66
    self.queueGap = 42
    self.queueSprites = {}
    for i=1,3 do
        local curQueueSprite = gfx.sprite.new()
        curQueueSprite:setCenter(0, 0)
        curQueueSprite:moveTo(self.queueBaseX, self.queueBaseY + (i - 1) * self.queueGap)
        curQueueSprite:add()
        self.queueSprites[i] = curQueueSprite
    end

    self.plantQueue = {}
    for _=1,3 do
        self:addNewPlantToQueue()
    end
    self:drawQueue()

    self.fastGrowth = 2000
    self.medGrowth = 4000
    self.slowGrowth = 6000
    self.verySlowGrowth = 8000
    self.superSlowGrowth = 10000
    self.plantGrowthTimes = {
        turnip = self.fastGrowth,
        potato = self.medGrowth,
        eggplant = self.slowGrowth,
        cherry = self.verySlowGrowth,
        apple = self.superSlowGrowth,
        pineapple = 12000,
        mushroom = self.slowGrowth,
        lettuce = self.verySlowGrowth,
        pumpkin = self.superSlowGrowth,
        carrot = self.medGrowth,
        pear = self.verySlowGrowth,
        grape = self.medGrowth,
        strawberry = 12000,
        corn = self.slowGrowth
    }

    local seedImage = gfx.image.new("images/garden/plants/seeds")
    seedImage:setInverted(true)
    self.seedImage = seedImage:scaledImage(2)

    self.playerHealthSprite = gfx.sprite.new()
    self.playerHealthSprite:setCenter(0, 0)
    self.playerHealthSprite:moveTo(53, 12)
    self.playerHealthSprite:add()
    self.playerHealthText = gfx.sprite.new()
    self.healthTextWidth = 40
    self.healthTextHeight = 22
    self.playerHealthText:setCenter(0, 0)
    self.playerHealthText:moveTo(3, 11)
    self.playerHealthText:add()

    self.enemyHealthSprite = gfx.sprite.new()
    self.enemyHealthSprite:setCenter(0, 0)
    self.enemyHealthSprite:moveTo(225, 12)
    self.enemyHealthSprite:add()
    self.enemyHealthText = gfx.sprite.new()
    self.enemyHealthText:setCenter(0, 0)
    self.enemyHealthText:moveTo(354, 11)
    self.enemyHealthText:add()

    self:drawPlayerHealth()
    self:drawEnemyHealth()

    self.levelTransitionPrompt = gfx.sprite.new()
    self.levelTransitionPrompt:setZIndex(500)
    self.levelTransitionPrompt:moveTo(200, -10)
    self.levelTransitionPrompt:add()
    self.level = 0

    self:levelDefeated()
    self.gameState = 'levelTransition'

    self.resultsSprite = gfx.sprite.new()
    self.resultsSprite:setZIndex(500)
    self.resultsSprite:moveTo(200, -50)
    self.resultsSprite:add()

    self.plantSound = pd.sound.sampleplayer.new("sound/garden/plant")
    self.sliceSound = pd.sound.sampleplayer.new("sound/battle/slice")
    self.hitSound = pd.sound.sampleplayer.new("sound/battle/hit")
    self.winSound = pd.sound.sampleplayer.new("sound/battle/win")
    self.loseSound = pd.sound.sampleplayer.new("sound/battle/lose")
    self.hurtSound = pd.sound.sampleplayer.new("sound/battle/hurt")
    self.powerUpSound = pd.sound.sampleplayer.new("sound/battle/powerUp")
    self.healSound = pd.sound.sampleplayer.new("sound/battle/heal")
    self.growthSound = pd.sound.sampleplayer.new("sound/battle/growth")

    self.battleMusic = pd.sound.sampleplayer.new("sound/battle/funnyBit")
    local menuItems = pd.getSystemMenu():getMenuItems()
    local musicOn = menuItems[1]:getValue()
    if musicOn then
        self.battleMusic:play(0)
    end

    self.lost = false

    self.playerMoved = false
    local refreshImage = gfx.image.new(50, 50, gfx.kColorWhite)
    self.refreshSprite = gfx.sprite.new(refreshImage)
    self.refreshSprite:setZIndex(-500)
    self.refreshSprite:moveTo(158, 139)
end

function BattleScene:update()
    if self.gameState == 'battle' then
        self:battleUpdate()
    elseif self.gameState == 'levelTransition' then
        self.levelTransitionPrompt:moveTo(self.levelTransitionAnimator:currentValue())
        if self.levelTransitionAnimator:ended() then
            local enemyConstructor = self:getEnemyConstructor()
            self.enemyInstance = enemyConstructor(self)
            self.enemyEntranceAnimator = gfx.animator.new(1000, self.enemyBaseX + 100, self.enemyBaseX, pd.easingFunctions.inOutCubic)
            self.enemyHealthAnimator = gfx.animator.new(1000, 0, self.enemyInstance.maxHealth, pd.easingFunctions.inOutCubic)
            self.gameState = 'loadNewEnemy'
            self.powerUpSound:play()
        end
    elseif self.gameState == 'loadNewEnemy' then
        self.enemyInstance.health = self.enemyHealthAnimator:currentValue()
        self:drawEnemyHealth()
        self.enemyInstance:moveTo(self.enemyEntranceAnimator:currentValue(), self.enemyInstance.y)
        if self.enemyEntranceAnimator:ended() then
            self.enemyInstance:createMoveTimer()
            self.gameState = 'battle'
        end
    elseif self.gameState == 'results' then
        self.playerSprite:moveTo(self.playerSprite.x, self.playerDeathAnimator:currentValue())
        self.resultsSprite:moveTo(self.resultsSprite.x, self.resultsAnimator:currentValue())
        if self.resultsAnimator:ended() then
            if pd.buttonJustPressed(pd.kButtonA) then
                PETS[SELECTED_PET].lastGamePlay = pd.getSecondsSinceEpoch()
                self.battleMusic:stop()
                SceneManager:switchScene(HomeScene)
            end
        end
    end
end

function BattleScene:levelDefeated()
    self.gameState = 'levelTransition'
    self.level += 1
    local levelText = "*Level: " .. self.level .. "*"
    local textWidth, textHeight = gfx.getTextSize(levelText)
    local textPadding = 3
    textWidth += textPadding * 2
    textHeight += textPadding * 2
    local textImage = gfx.image.new(textWidth, textHeight)
    gfx.pushContext(textImage)
        gfx.fillRoundRect(0, 0, textWidth, textHeight, 3)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawTextAligned(levelText, textWidth / 2, (textHeight - 16) / 2, kTextAlignment.center)
    gfx.popContext()
    self.levelTransitionPrompt:setImage(textImage)

    local line1 = pd.geometry.lineSegment.new(200, -20, 200, 120)
    local line2 = pd.geometry.lineSegment.new(200, 120, 200, 120)
    local line3 = pd.geometry.lineSegment.new(200, 120, 200, -20)
    self.levelTransitionAnimator = gfx.animator.new({1000, 1000, 1000}, {line1, line2, line3}, {pd.easingFunctions.inOutCubic, pd.easingFunctions.linear, pd.easingFunctions.inOutCubic})
    for x=1,3 do
        for y=1,3 do
            local gardenPlot = self.gardenGrid[x][y]
            if gardenPlot then
                if gardenPlot.growthTimer then
                    gardenPlot.growthTimer:remove()
                end
                self.gardenGrid[x][y] = nil
            end
        end
    end
    self:drawGarden()
end

function BattleScene:battleUpdate()
    if pd.buttonJustPressed(pd.kButtonLeft) then
        self:movePlayer(-1, 0)
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        self:movePlayer(1, 0)
    elseif pd.buttonJustPressed(pd.kButtonUp) then
        self:movePlayer(0, -1)
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        self:movePlayer(0, 1)
    end

    if pd.buttonJustPressed(pd.kButtonA) then
        local plotData = self.gardenGrid[self.playerX][self.playerY]
        if plotData then
            self:harvestPlant(plotData)
        else
            self:plantSeed()
        end
    end
end

function BattleScene:movePlayer(x, y)
    if not self.playerMoved then
        self.playerMoved = true
        self.refreshSprite:add()
    end
    self.playerX += x
    if self.playerX < 1 then
        self.playerX = 1
    elseif self.playerX > 3 then
        self.playerX = 3
    end

    self.playerY += y
    if self.playerY < 1 then
        self.playerY = 1
    elseif self.playerY > 3 then
        self.playerY = 3
    end

    self.playerSprite:moveTo(self.gridBaseX + (self.playerX - 1) * self.gridGap, self.gridBaseY + (self.playerY - 1) * self.gridGap)
end

function BattleScene:drawPlayerHealth()
    local healthWidth, healthHeight = 122, 20
    local playerHealthImage = gfx.image.new(122, 20)
    gfx.pushContext(playerHealthImage)
        gfx.fillRect(0, 0, (self.playerHealth / self.playerMaxHealth) * healthWidth, healthHeight)
    gfx.popContext()
    self.playerHealthSprite:setImage(playerHealthImage)
    local playerHealthTextImage = gfx.image.new(self.healthTextWidth, self.healthTextHeight)
    gfx.pushContext(playerHealthTextImage)
        gfx.drawTextAligned("*"..math.ceil(self.playerHealth).."*", self.healthTextWidth, (self.healthTextHeight - 16) / 2, kTextAlignment.right)
    gfx.popContext()
    self.playerHealthText:setImage(playerHealthTextImage)
end

function BattleScene:drawEnemyHealth()
    if not self.enemyInstance then
        return
    end

    local healthWidth, healthHeight = 122, 20
    local enemyHealthImage = gfx.image.new(122, 20)
    gfx.pushContext(enemyHealthImage)
        gfx.fillRect(0, 0, (self.enemyInstance.health / self.enemyInstance.maxHealth) * healthWidth, healthHeight)
    gfx.popContext()
    self.enemyHealthSprite:setImage(enemyHealthImage)
    local enemyHealthTextImage = gfx.image.new(self.healthTextWidth, self.healthTextHeight)
    gfx.pushContext(enemyHealthTextImage)
        gfx.drawTextAligned("*"..math.ceil(self.enemyInstance.health).."*", 0, (self.healthTextHeight - 16) / 2, kTextAlignment.left)
    gfx.popContext()
    self.enemyHealthText:setImage(enemyHealthTextImage)
end

function BattleScene:drawGarden()
    for x=1,3 do
        for y=1,3 do
            local gardenPlot = self.gardenGrid[x][y]
            local gardenSprite = self.gardenSprites[x][y]
            if gardenPlot then
                gardenSprite:setVisible(true)
                if not gardenPlot.grown then
                    gardenSprite:setImage(self.seedImage)
                else
                    local plantType = gardenPlot.plant
                    gardenSprite:setImage(self.plantImages[plantType])
                end
            else
                gardenSprite:setVisible(false)
            end
        end
    end
end

function BattleScene:plantSeed()
    self.plantSound:play()
    local nextSeed = table.remove(self.plantQueue, 1)
    self:addNewPlantToQueue()
    self:drawQueue()
    local curPlayerX, curPlayerY = self.playerX, self.playerY
    self.gardenGrid[self.playerX][self.playerY] = {
        plant = nextSeed,
        grown = false,
        growthTimer = pd.timer.new(self.plantGrowthTimes[nextSeed], function()
            self.gardenGrid[curPlayerX][curPlayerY].grown = true
            self:drawGarden()
        end)
    }
    self:drawGarden()
end

function BattleScene:drawQueue()
    for i=1,3 do
        local queuePlant = self.plantQueue[i]
        local plantImage = gfx.image.new("images/garden/plants/" .. queuePlant)
        plantImage:setInverted(true)
        self.queueSprites[i]:setImage(plantImage:scaledImage(2))
    end
end

function BattleScene:addNewPlantToQueue()
    if #self.plantDeck > 0 then
        local newPlant = self.plantDeck[math.random(#self.plantDeck)]
        table.insert(self.plantQueue, newPlant)
    else
        table.insert(self.plantQueue, 'turnip')
    end
end

function BattleScene:createAttackSprite(row)
    local attackX = self.enemyBaseX - 5
    local attackY = self.enemyBaseY + (row - 1) * self.enemyGap - 5
    PlayerAttackSprite(attackX, attackY)
end

function BattleScene:damageEnemy(dmg, row)
    if not self.enemyInstance then
        return
    end
    if row == self.enemyInstance.row then
        self.hitSound:play()
        self.enemyInstance:damage(dmg)
        if self.enemyInstance.health <= 0 then
            self:drawEnemyHealth()
            self.enemyInstance = nil
            self.winSound:play()
            self:levelDefeated()
        end
        self:drawEnemyHealth()
    end
end

function BattleScene:createWarning(x, y)
    local warningX = self.gridBaseX + (x-1)*self.gridGap - 10
    local warningY = self.gridBaseY + (y-1)*self.gridGap - 9
    WarningIcon(warningX, warningY)
end

function BattleScene:damagePlayer(dmg, x, y)
    if self.lost then
        return
    end

    if x == self.playerX and y == self.playerY then
        self.hurtSound:play()
        self.playerHealth -= dmg
        self.playerSprite:setVisible(false)
        pd.timer.new(100, function()
            self.playerSprite:setVisible(true)
        end)
        if self.playerHealth <= 0 then
            self.playerHealth = 0
            self:playerDied()
        end
        self:drawPlayerHealth()
    end
end

function BattleScene:playerDied()
    self.lost = true
    self.loseSound:play()
    self.gameState = 'results'
    local resultsImageWidth, resultsImageHeight = 160, 110
    local resultsImage = gfx.image.new(resultsImageWidth, resultsImageHeight)
    if self.enemyInstance then
        self.enemyInstance.moveTimer:remove()
    end
    gfx.pushContext(resultsImage)
        gfx.fillRoundRect(0, 0, resultsImageWidth, resultsImageHeight, 3)
        gfx.setColor(gfx.kColorWhite)
        local border = 3
        gfx.fillRoundRect(border, border, resultsImageWidth - border*2, resultsImageHeight - border*2, 3)
        gfx.drawTextAligned("LVL  " .. self.level .. "  CLEAR!", resultsImageWidth / 2, 10, kTextAlignment.center)
        local gemImage = gfx.image.new("images/shop/gem")
        local gemAmount = self.level * 5
        GEMS += gemAmount
        gemImage:draw(50, 35)
        gfx.drawText(gemAmount, 75, 35)
        local xpGained = math.floor(self.level^1.4 + 2)
        local curXP = PETS[SELECTED_PET].xp
        local curLvl = PETS[SELECTED_PET].level
        local newLevel = math.floor((curXP + xpGained) ^ (1 / 3) - 1)
        local levelText = tostring(newLevel)
        if curLvl ~= newLevel then
            levelText = levelText .. " *LVL UP*"
        end
        PETS[SELECTED_PET].xp = curXP + xpGained
        PETS[SELECTED_PET].level = newLevel

        gfx.drawText("*XP: *", 43, 60)
        gfx.drawText(xpGained, 75, 60)
        gfx.drawText("*Pet Lvl:* ", 10, 85)
        gfx.drawText(levelText, 75, 85)
    gfx.pushContext()
    self.resultsSprite:setImage(resultsImage)
    self.playerDeathAnimator = gfx.animator.new(1000, self.playerSprite.y, 260, pd.easingFunctions.inBack)
    self.resultsAnimator = gfx.animator.new(1200, self.resultsSprite.y, 120, pd.easingFunctions.inOutCubic)
end

function BattleScene:attackSingle(dmg, delay)
    local attackRow = self.playerY
    pd.timer.new(delay, function()
        self.sliceSound:play()
        self:createAttackSprite(attackRow)
        self:damageEnemy(dmg, attackRow)
    end)
end

function BattleScene:attackArea(dmg)
    self.sliceSound:play()
    for i=1,3 do
        self:createAttackSprite(i)
        self:damageEnemy(dmg, i)
    end
end

function BattleScene:heal(amount)
    self.healSound:play()
    self.playerHealth += amount
    if self.playerHealth >= self.playerMaxHealth then
        self.playerHealth = self.playerMaxHealth
    end
    self:drawPlayerHealth()
end

function BattleScene:shield()
    
end

function BattleScene:growAll()
    self.growthSound:play()
    for x=1,3 do
        for y=1,3 do
            local gardenPlot = self.gardenGrid[x][y]
            if gardenPlot then
                if gardenPlot.growthTimer then
                    gardenPlot.growthTimer:remove()
                end
                self.gardenGrid[x][y].grown = true
            end
        end
    end
    self:drawGarden()
end

function BattleScene:growRow()
    self.growthSound:play()
    local y = self.playerY
    for x=1,3 do
        local gardenPlot = self.gardenGrid[x][y]
        if gardenPlot then
            if gardenPlot.growthTimer then
                gardenPlot.growthTimer:remove()
            end
            self.gardenGrid[x][y].grown = true
        end
    end
    self:drawGarden()
end

function BattleScene:harvestPlant(plotData)
    if not plotData.grown then
        return
    end

    local plant = plotData.plant
    if plant == "turnip" then
        self:attackSingle(5, 0)
    elseif plant == "potato" then
        self:attackSingle(10, 0)
    elseif plant == "eggplant" then
        self:attackSingle(15, 0)
    elseif plant == "cherry" then
        self:heal(1)
    elseif plant == "apple" then
        self:heal(2)
    elseif plant == "pineapple" then
        self:heal(3)
    elseif plant == "mushroom" then
        self:attackArea(2)
    elseif plant == "lettuce" then
        self:attackArea(4)
    elseif plant == "pumpkin" then
        self:attackArea(8)
    elseif plant == "carrot" then
        self:attackSingle(15, 500)
    elseif plant == "pear" then
        self:heal(1)
        self:attackSingle(5, 0)
    elseif plant == "grape" then
        self:attackSingle(5, 0)
        self:attackSingle(5, 500)
        self:attackSingle(5, 1000)
    elseif plant == "strawberry" then
        self:growAll()
    elseif plant == "corn" then
        self:growRow()
    end

    self.gardenGrid[self.playerX][self.playerY] = nil
    self:drawGarden()
end

function BattleScene:getEnemyConstructor()
    local constructors
    if self.level <= 5 then
        constructors = {Goblin, Wendigo, Mimic}
    elseif self.level <= 10 then
        constructors = {Mermaid, Cyclops, Mandrake}
    elseif self.level <= 15 then
        constructors = {Kitsune, Phoenix, Cerberus}
    else
        constructors = {Gargoyle, Dragon, Djinn, Kraken}
    end
    return constructors[math.random(#constructors)]
end