-- This is the shop scene. There's not really anything technically challenging about this
-- code, it's all a bunch of UI work and figuring out how to get the right data and display it.
-- So much UI work... 😭 I really should make some sort of UI library...

import "scripts/home/homeScene"
import "scripts/petHatch/petHatchScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('ShopScene').extends(gfx.sprite)

function ShopScene:init()
    local shopBackground = gfx.image.new("images/shop/shopBackground")
    self:setImage(shopBackground)
    self:moveTo(200, 120)
    self:add()

    self:generateDailyItems()

    self.shopGrid = pd.ui.gridview.new(22, 22)
    self.shopGrid:setNumberOfColumns(3)
    self.shopGrid:setNumberOfRows(2)

    self.shopGrid:setCellPadding(10, 7, 10, 7)

    self.shopGridObject = getmetatable(self.shopGrid)
    self.shopGridObject.imageOffset = 4
    self.shopGridObject.selectorImage = gfx.image.new("images/shop/shopSelector")
    self.shopGridObject.selectorXOffset = -6
    self.shopGridObject.selectorYOffset = -4

    self.shopGridWidth = 140
    self.shopGridHeight = 87
    self.shopGridPadding = 20

    function self.shopGrid:drawCell(section, row, column, selected, x, y, width, height)
        if selected then
            self.selectorImage:draw(x + self.selectorXOffset, y + self.selectorYOffset)
        end
        local shopIndex = (row-1)*3+column
        if shopIndex == 5 then
            local shovelImage = gfx.image.new("images/shop/shovel")
            shovelImage:draw(x + self.imageOffset, y + self.imageOffset)
        elseif shopIndex == 6 then
            local eggImage = gfx.image.new("images/shop/egg")
            eggImage:draw(x + self.imageOffset, y + self.imageOffset)
        else
            local shopItem = DAILY_SHOP_ITEMS.shopItems[shopIndex]
            gfx.setImageDrawMode(gfx.kDrawModeInverted)
            local plantImage = gfx.image.new("images/garden/plants/"..shopItem.plant)
            plantImage:draw(x + self.imageOffset, y + self.imageOffset)
            gfx.setImageDrawMode(gfx.kDrawModeCopy)
        end
    end

    self.shopGridSprite = gfx.sprite.new(self.shopGridWidth, self.shopGridHeight)
    self.shopGridSprite:setCenter(0, 0)
    self.shopGridSprite:moveTo(103 + 9, 25 - 5)
    self.shopGridSprite:add()

    self.shopItemInfoWidth = 100
    self.shopItemInfoHeight = 119
    self.shopItemInfoSprite = gfx.sprite.new(self.shopItemInfoWidth, self.shopItemInfoHeight)
    self.shopItemInfoSprite:setCenter(0, 0)
    self.shopItemInfoSprite:moveTo(282, 37)
    self.shopItemInfoSprite:add()

    self.gemCountWidth = 100
    self.gemCountHeight = 46
    self.gemCountSprite = gfx.sprite.new(self.gemCountWidth, self.gemCountHeight)
    self.gemCountSprite:setCenter(0, 0)
    self.gemCountSprite:moveTo(282, 174)
    self.gemCountSprite:add()

    self.petCount = 0
    for _, _ in pairs(PETS) do
        self.petCount += 1
    end

    self.eggPurchased = false

    self.humSound = pd.sound.sampleplayer.new("sound/shop/hum")
    self.purchaseSound = pd.sound.sampleplayer.new("sound/shop/purchase")
    self.clickSound = pd.sound.sampleplayer.new("sound/UI/click")
    self.humSound:play(0)
end

function ShopScene:update()
    local forceUpdate = false

    if pd.buttonJustPressed(pd.kButtonDown) then
        self.clickSound:play()
        self.shopGrid:selectNextRow(false)
    elseif pd.buttonJustPressed(pd.kButtonUp) then
        self.clickSound:play()
        self.shopGrid:selectPreviousRow(false)
    elseif pd.buttonJustPressed(pd.kButtonLeft) then
        self.clickSound:play()
        self.shopGrid:selectPreviousColumn(false)
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        self.clickSound:play()
        self.shopGrid:selectNextColumn(false)
    end

    if pd.buttonJustPressed(pd.kButtonA) then
        local shopIndex = self:getShopIndex()
        if shopIndex == 5 then
            if GARDEN_LEVEL < #GARDEN_LEVELS then
                local gardenUpgradePrice = self:getGardenUpgradePrice()
                if GEMS >= gardenUpgradePrice then
                    self.purchaseSound:play()
                    forceUpdate = true
                    GEMS -= gardenUpgradePrice
                    GARDEN_LEVEL += 1
                end
            end
        elseif shopIndex == 6 then
            local eggPrice = self:getEggPrice()
            if GEMS >= eggPrice and not self.eggPurchased then
                self.purchaseSound:play()
                self.humSound:stop()
                self.eggPurchased = true
                forceUpdate = true
                GEMS -= eggPrice
                SceneManager:switchScene(PetHatchScene)
            end
        else
            local shopItem = self:getSelectedItem()
            local shopItemName = shopItem.plant
            local shopItemPrice = shopItem.price
            if GEMS >= shopItemPrice then
                self.purchaseSound:play()
                forceUpdate = true
                GEMS -= shopItemPrice
                PLANT_INVENTORY[shopItemName].seeds += 1
            end
        end
    end

    if pd.buttonJustPressed(pd.kButtonB) then
        self.humSound:stop()
        SceneManager:switchScene(HomeScene)
    end

    if self.shopGrid.needsDisplay or forceUpdate then
        local shopGridImage = gfx.image.new(self.shopGridWidth + self.shopGridPadding, self.shopGridHeight + self.shopGridPadding)
        gfx.pushContext(shopGridImage)
            self.shopGrid:drawInRect(0, 0, self.shopGridWidth + self.shopGridPadding, self.shopGridHeight + self.shopGridPadding)
        gfx.popContext()
        self.shopGridSprite:setImage(shopGridImage)

        local shopIndex = self:getShopIndex()
        if shopIndex == 5 then
            self:drawGardenUpgradeInfo()
        elseif shopIndex == 6 then
            self:drawEggInfo()
        else
            self:drawSeedItemInfo()
        end

        local gemsTextImage = gfx.image.new(self.gemCountWidth, self.gemCountHeight)
        gfx.pushContext(gemsTextImage)
            gfx.drawText(GEMS, 46, 15)
        gfx.popContext()
        self.gemCountSprite:setImage(gemsTextImage)
    end
end

function ShopScene:getGardenUpgradePrice()
    return GARDEN_LEVEL * 50
end

function ShopScene:getEggPrice()
    return self.petCount * 50
end

function ShopScene:drawGardenUpgradeInfo()
    local shovelImage = gfx.image.new("images/shop/shovel")
    local gardenUpgradePrice = self:getGardenUpgradePrice()
    local shopItemInfoImage = gfx.image.new(self.shopItemInfoWidth, self.shopItemInfoHeight)
    gfx.pushContext(shopItemInfoImage)
        shovelImage:draw(42, 16)
        if GARDEN_LEVEL < #GARDEN_LEVELS then
            gfx.drawText(gardenUpgradePrice, 47, 40)
            local gardenUpgradeData = GARDEN_LEVELS[GARDEN_LEVEL + 1]
            local gardenWidth = gardenUpgradeData.maxCol - gardenUpgradeData.minCol + 1
            local gardenHeight = gardenUpgradeData.maxRow - gardenUpgradeData.minRow + 1
            gfx.drawTextInRect("*" .. gardenWidth .. "x" .. gardenHeight .. "* garden!", 6, 70, 88, 45, nil, nil, kTextAlignment.center)
        else
            gfx.drawText("--", 47, 40)
            gfx.drawTextInRect("Max garden upgrade!", 6, 70, 88, 45, nil, nil, kTextAlignment.center)
        end
    gfx.popContext()
    self.shopItemInfoSprite:setImage(shopItemInfoImage)
end

function ShopScene:drawEggInfo()
    local eggImage = gfx.image.new("images/shop/egg")
    local eggPrice = self:getEggPrice()
    local shopItemInfoImage = gfx.image.new(self.shopItemInfoWidth, self.shopItemInfoHeight)
    gfx.pushContext(shopItemInfoImage)
        eggImage:draw(42, 16)
        gfx.drawText(eggPrice, 47, 40)
        gfx.drawTextInRect("Random new pet!", 6, 70, 88, 45, nil, nil, kTextAlignment.center)
    gfx.popContext()
    self.shopItemInfoSprite:setImage(shopItemInfoImage)
end

function ShopScene:drawSeedItemInfo()
    local shopItem = self:getSelectedItem()
    local shopItemName = shopItem.plant
    local shopItemPrice = shopItem.price
    local plantImage = gfx.image.new("images/garden/plants/"..shopItemName)
    local plantInInventory = PLANT_INVENTORY[shopItemName].plant
    local seedsInInventory = PLANT_INVENTORY[shopItemName].seeds
    local shopItemInfoImage = gfx.image.new(self.shopItemInfoWidth, self.shopItemInfoHeight)
    gfx.pushContext(shopItemInfoImage)
        gfx.setImageDrawMode(gfx.kDrawModeInverted)
        plantImage:draw(42, 16)
        plantImage:draw(22, 95)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        local seedShopIcon = gfx.image.new("images/shop/seedShopIcon")
        seedShopIcon:draw(22, 71)
        gfx.drawText(shopItemPrice, 47, 40)
        gfx.drawText(seedsInInventory, 49, 70)
        gfx.drawText(plantInInventory, 49, 95)
    gfx.popContext()
    self.shopItemInfoSprite:setImage(shopItemInfoImage)
end

function ShopScene:generateDailyItems()
    local dsi = DAILY_SHOP_ITEMS
    local curTime = pd.getTime()
    local curYear, curMonth, curDay = curTime.year, curTime.month, curTime.day
    if not DAILY_SHOP_ITEMS or (curYear ~= dsi.year or curMonth ~= dsi.month or curDay ~= dsi.day) then
        DAILY_SHOP_ITEMS = {}
        DAILY_SHOP_ITEMS.year = curYear
        DAILY_SHOP_ITEMS.month = curMonth
        DAILY_SHOP_ITEMS.day = curDay
        local shuffledPlants = {}
        for _, plant in ipairs(PLANTS_IN_ORDER) do
            local pos = math.random(1, #shuffledPlants+1)
            table.insert(shuffledPlants, pos, plant)
        end

        local dailyPlants = {}
        self.minPrice = 5
        self.maxPrice = 20
        for i=1,4 do
            local plantPrice = math.random(self.minPrice, self.maxPrice)
            table.insert(dailyPlants, {
                plant = shuffledPlants[i],
                price = plantPrice
            })
        end
        DAILY_SHOP_ITEMS.shopItems = dailyPlants
    end
end

function ShopScene:getSelectedItem()
    local _, row, column = self.shopGrid:getSelection()
    return DAILY_SHOP_ITEMS.shopItems[(row-1)*3+column]
end

function ShopScene:getShopIndex()
    local _, row, column = self.shopGrid:getSelection()
    return (row-1)*3+column
end