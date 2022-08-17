
PLANTS = {
    turnip = {
        cost = 10
    },
    eggplant = {
        cost = 10
    },
    lettuce = {
        cost = 10
    },
    cherry = {
        cost = 10
    },
    potato = {
        cost = 10
    },
    carrot = {
        cost = 10
    },
    mushroom = {
        cost = 10
    },
    pumpkin = {
        cost = 10
    },
    pineapple = {
        cost = 10
    },
    apple = {
        cost = 10
    },
    pear = {
        cost = 10
    },
    corn = {
        cost = 10
    },
    strawberry = {
        cost = 10
    },
    grape = {
        cost = 10
    }
}

PLANTS_IN_ORDER = {'turnip', 'eggplant', 'lettuce', 'cherry', 'potato', 'carrot', 'mushroom', 'pumpkin', 'pineapple', 'apple', 'pear', 'corn', 'strawberry', 'grape'}

PLANT_INVENTORY = {}

for key in pairs(PLANTS) do
    PLANT_INVENTORY[key] = {
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

