
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

PLANT_INVENTORY = {}

for key in pairs(PLANTS) do
    PLANT_INVENTORY[key] = {
        seeds = 10,
        plant = 10
    }
end