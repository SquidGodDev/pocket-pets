
local pd <const> = playdate
local gfx <const> = pd.graphics

function IS_DAYTIME()
    return pd.getTime().hour >= 7 and pd.getTime().hour <= 18
    -- return true
end

function GET_PET_IMAGETABLE(pet)
    local petData = PETS[pet]
    local petType = petData.type
    local petLevel = petData.level
    local petEvolution = petData.petEvolution
    if petLevel <= 5 then
        return gfx.imagetable.new("images/pets/baby-table-32-32")
    elseif petLevel <= 15 or petEvolution == nil then
        if petType == "bat" then
            return gfx.imagetable.new("images/pets/mouse-table-32-32")
        elseif petType == "buffBunny" then
            return gfx.imagetable.new("images/pets/bunny-table-32-32")
        elseif petType == "chicken" then
            return gfx.imagetable.new("images/pets/chick-table-32-32")
        elseif petType == "crab" then
            return gfx.imagetable.new("images/pets/miniCrab-table-32-32")
        elseif petType == "dog" then
            return gfx.imagetable.new("images/pets/dog-table-32-32")
        elseif petType == "duck" then
            return gfx.imagetable.new("images/pets/chick2-table-32-32")
        elseif petType == "hedgehog" then
            return gfx.imagetable.new("images/pets/hedgehog-table-32-32")
        elseif petType == "snake" then
            return gfx.imagetable.new("images/pets/snail-table-32-32")
        elseif petType == "whale" then
            return gfx.imagetable.new("images/pets/fish-table-32-32")
        elseif petType == "wingedUnicorn" then
            return gfx.imagetable.new("images/pets/horse-table-32-32")
        else
            return gfx.imagetable.new("images/pets/"..petType.."-table-32-32")
        end
    else
        if petType == "bat" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/bat-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/rat-table-32-32")
            end
        elseif petType == "buffBunny" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/buffBunny-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/chubbyBunny-table-32-32")
            end
        elseif petType == "cat" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/sleepyCat-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/existentialCat-table-32-32")
            end
        elseif petType == "chicken" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/sparrow-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/chicken-table-32-32")
            end
        elseif petType == "crab" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/crab-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/shrimp-table-32-32")
            end
        elseif petType == "dog" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/dingo-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/reindeer-table-32-32")
            end
        elseif petType == "duck" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/swan-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/duck-table-32-32")
            end
        elseif petType == "hedgehog" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/camel-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/twinBunnies-table-32-32")
            end
        elseif petType == "snake" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/snake-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/lochness-table-32-32")
            end
        elseif petType == "whale" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/whale-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/squid-table-32-32")
            end
        elseif petType == "wingedUnicorn" then
            if petEvolution == 1 then
                return gfx.imagetable.new("images/pets/pegasus-table-32-32")
            elseif petEvolution == 2 then
                return gfx.imagetable.new("images/pets/unicorn-table-32-32")
            end
        end
    end
end