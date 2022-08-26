-- === SHOP ===
GEMS = 0
DAILY_SHOP_ITEMS = nil

-- === WISH ===
WISH_GRANTED = false
WISH_GRANT_TIME = {
    year = 1999,
    month = 12,
    day = 31
}

-- === PETS ===
PET_TYPES = {'bat', 'buffBunny', 'cat', 'chicken', 'crab', 'dog', 'duck', 'hedgehog', 'snake', 'whale', 'wingedUnicorn'}

SELECTED_PET = ""

PETS = {}
-- PETS = {
--     Hachi = {
--         type = "dog",
--         hunger = {
--             level = 50,
--             lastTime = playdate.getTime()
--         },
--         lastPet = playdate.getTime(),
--         lastGamePlay = playdate.getTime(),
--         level = 0,
--         xp = 0,
--         plantDeck = {'carrot', 'grape', 'potato', 'turnip', 'eggplant', 'strawberry', 'apple', 'pear'}
--     }
-- }

-- === GARDEN ===
PLANTS_IN_ORDER = {'turnip', 'eggplant', 'lettuce', 'cherry', 'potato', 'carrot', 'mushroom', 'pumpkin', 'pineapple', 'apple', 'pear', 'corn', 'strawberry', 'grape'}

PLANT_INVENTORY = {}
for _, plant in ipairs(PLANTS_IN_ORDER) do
    PLANT_INVENTORY[plant] = {
        seeds = 0,
        plant = 0
    }
end
PLANT_INVENTORY['turnip'].seeds = 10

GARDEN_DATA = {}
for row=1,5 do
    GARDEN_DATA[row] = {}
    for col=1,8 do
        GARDEN_DATA[row][col] = nil
    end
end

GARDEN_LEVEL = 1

-- === BATTLE ===


-- === SAVING AND LOADING ===

local function saveGameData()
    local gameData = {
        gems = GEMS,
        dailyShopItems = DAILY_SHOP_ITEMS,
        wishGranted = WISH_GRANTED,
        wishGrantTime = WISH_GRANT_TIME,
        selectedPet = SELECTED_PET,
        pets = PETS,
        plantInventory = PLANT_INVENTORY,
        gardenData = GARDEN_DATA,
        gardenLevel = GARDEN_LEVEL
    }
    playdate.datastore.write(gameData)
end

local function loadGameData()
    local gameData = playdate.datastore.read()
    if gameData then
        GEMS = gameData.gems
        DAILY_SHOP_ITEMS = gameData.dailyShopItems
        WISH_GRANTED = gameData.wishGranted
        WISH_GRANT_TIME = gameData.wishGrantTime
        SELECTED_PET = gameData.selectedPet
        PETS = gameData.pets
        PLANT_INVENTORY = gameData.plantInventory
        GARDEN_DATA = gameData.gardenData
        GARDEN_LEVEL = gameData.gardenLevel
    end
end

loadGameData()

function playdate.gameWillTerminate()
    saveGameData()
end

function playdate.gameWillSleep()
    saveGameData()
end


GARDEN_LEVELS = {
    {
        minRow = 3,
        maxRow = 3,
        minCol = 4,
        maxCol = 5
    },
    {
        minRow = 2,
        maxRow = 3,
        minCol = 4,
        maxCol = 5
    },
    {
        minRow = 2,
        maxRow = 4,
        minCol = 4,
        maxCol = 5
    },
    {
        minRow = 2,
        maxRow = 4,
        minCol = 3,
        maxCol = 5
    },
    {
        minRow = 2,
        maxRow = 4,
        minCol = 3,
        maxCol = 6
    },
    {
        minRow = 2,
        maxRow = 4,
        minCol = 2,
        maxCol = 6
    },
    {
        minRow = 2,
        maxRow = 4,
        minCol = 2,
        maxCol = 7
    },
    {
        minRow = 1,
        maxRow = 4,
        minCol = 2,
        maxCol = 7
    },
    {
        minRow = 1,
        maxRow = 5,
        minCol = 2,
        maxCol = 7
    },
    {
        minRow = 1,
        maxRow = 5,
        minCol = 1,
        maxCol = 7
    },
    {
        minRow = 1,
        maxRow = 5,
        minCol = 1,
        maxCol = 8
    }
}