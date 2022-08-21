
-- === SHOP ===
GEMS = 10000
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
--             level = 10,
--             lastTime = playdate.getTime()
--         },
--         lastPet = playdate.getTime(),
--         lastGamePlay = playdate.getTime(),
--         level = 1,
--         xp = 0
--     },
--     ssssssss = {
--         type = "snake",
--         hunger = {
--             level = 50,
--             lastTime = playdate.getTime()
--         },
--         lastPet = playdate.getTime(),
--         lastGamePlay = playdate.getTime(),
--         level = 1,
--         xp = 0
--     },
--     Yuki = {
--         type = "duck",
--         hunger = {
--             level = 50,
--             lastTime = playdate.getTime()
--         },
--         lastPet = playdate.getTime(),
--         lastGamePlay = playdate.getTime(),
--         level = 1,
--         xp = 0
--     }
-- }

-- === GARDEN ===
PLANTS_IN_ORDER = {'turnip', 'eggplant', 'lettuce', 'cherry', 'potato', 'carrot', 'mushroom', 'pumpkin', 'pineapple', 'apple', 'pear', 'corn', 'strawberry', 'grape'}

PLANT_INVENTORY = {}
for _, plant in ipairs(PLANTS_IN_ORDER) do
    PLANT_INVENTORY[plant] = {
        seeds = 10,
        plant = 10
    }
end

GARDEN_DATA = {}
for row=1,5 do
    GARDEN_DATA[row] = {}
    for col=1,8 do
        GARDEN_DATA[row][col] = nil
    end
end

GARDEN_LEVEL = 1

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