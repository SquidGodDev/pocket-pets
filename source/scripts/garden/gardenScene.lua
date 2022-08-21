import "scripts/garden/gardenGrid"
import "scripts/garden/seedList"
import "scripts/garden/GardenDataDisplay"
import "scripts/home/homeScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('GardenScene').extends(gfx.sprite)

function GardenScene:init()
    local background = gfx.image.new("images/garden/gardenBackground")
    self:moveTo(200, 120)
    self:setImage(background)
    self:add()

    local minRow = GARDEN_LEVELS[GARDEN_LEVEL].minRow
    local maxRow = GARDEN_LEVELS[GARDEN_LEVEL].maxRow
    local minCol = GARDEN_LEVELS[GARDEN_LEVEL].minCol
    local maxCol = GARDEN_LEVELS[GARDEN_LEVEL].maxCol
    self.seedList = SeedList()
    local gardenGrid = GardenGrid(minRow, maxRow, minCol, maxCol, self.seedList)
    GardenDataDisplay(self.seedList, gardenGrid)
end

function GardenScene:update()
    if pd.buttonJustPressed(pd.kButtonB) and not self.seedList.listOut then
        SceneManager:switchScene(HomeScene)
    end
end