GEMS = 100
WISH_GRANTED = false
WISH_GRANT_TIME = {
    year = 1999,
    month = 12,
    day = 31
}

PLANTS_IN_ORDER = {'turnip', 'eggplant', 'lettuce', 'cherry', 'potato', 'carrot', 'mushroom', 'pumpkin', 'pineapple', 'apple', 'pear', 'corn', 'strawberry', 'grape'}

DAILY_SHOP_ITEMS = nil
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

