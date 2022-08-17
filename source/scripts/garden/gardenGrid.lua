local pd <const> = playdate
local gfx <const> = pd.graphics

class('GardenGrid').extends(gfx.sprite)

function GardenGrid:init(minRow, maxRow, minCol, maxCol, seedList)
    self.seedList = seedList

    self.gridview = pd.ui.gridview.new(36, 36)
    self.maxCols = 8
    self.maxRows = 5
    self.gridview:setNumberOfColumns(self.maxCols)
    self.gridview:setNumberOfRows(self.maxRows)

    self.gridWidth = 358
    self.gridHeight = 220
    self.edgePadding = 10
    self.gridview:setCellPadding(self.edgePadding / 2, 5, self.edgePadding / 2, 5)

    self.gridviewObject = getmetatable(self.gridview)
    self.gridviewObject.plotImage = gfx.image.new("images/garden/gardenPlot")
    self.gridviewObject.selectorImage = gfx.image.new("images/garden/plotSelector")

    self.minCol = minCol
    self.maxCol = maxCol
    self.minRow = minRow
    self.maxRow = maxRow
    self.gridviewObject.minCol = self.minCol
    self.gridviewObject.maxCol = self.maxCol
    self.gridviewObject.minRow = self.minRow
    self.gridviewObject.maxRow = self.maxRow
    self.gridviewObject.seedsImage = gfx.image.new("images/garden/plants/seeds")
    self.gridviewObject.plantOffset = 10

    self.gridview:setSelection(1, 3, 4)

    function self.gridview:drawCell(section, row, column, selected, x, y, width, height)
        if row < self.minRow or row > self.maxRow or column < self.minCol or column > self.maxCol then
            return
        end
        if selected then
            local selectorWidth = self.selectorImage:getSize()
            local selectorOffset = (selectorWidth - width) / 2
            self.selectorImage:draw(x - selectorOffset, y - selectorOffset)
        end
        self.plotImage:draw(x, y)
        local plotData = GARDEN_DATA[row][column]
        if plotData then
            if plotData.grown then
                local plantName = plotData.plant
                local plantImage = gfx.image.new("images/garden/plants/" .. plantName)
                plantImage:draw(x + self.plantOffset, y + self.plantOffset)
            else
                self.seedsImage:draw(x + self.plantOffset, y + self.plantOffset)
            end
        end
    end

    self:setCenter(0, 0)
    self:moveTo(21 - self.edgePadding / 2, 10 - self.edgePadding / 2)
    self:add()
end

function GardenGrid:update()
    local _, row, column = self.gridview:getSelection()
    local forceRedrawGrid = false

    forceRedrawGrid = self:updatePlants()

    if pd.buttonJustPressed(pd.kButtonA) then
        local plotData = GARDEN_DATA[row][column]
        local selectedPlant = self.seedList:getSelectedPlant()
        if not plotData then
            local plantSeeds = PLANT_INVENTORY[selectedPlant].seeds
            if plantSeeds > 0 then
                PLANT_INVENTORY[selectedPlant].seeds -= 1
                GARDEN_DATA[row][column] = {
                    plant = selectedPlant,
                    grown = false,
                    growTime = self:getRandomGrowthTime()
                }
                forceRedrawGrid = true
            end
        else
            if plotData.grown then
                PLANT_INVENTORY[selectedPlant].plant += 1
                GARDEN_DATA[row][column] = nil
                forceRedrawGrid = true
            end
        end
    end

    if pd.buttonJustPressed(pd.kButtonUp) then
        if row > self.minRow then
            self.gridview:selectPreviousRow(true)
        end
    elseif pd.buttonJustPressed(pd.kButtonDown) then
        if row < self.maxRow then
            self.gridview:selectNextRow(true)
        end
    elseif pd.buttonJustPressed(pd.kButtonLeft) then
        if column > self.minCol then
            self.gridview:selectPreviousColumn(true)
        end
    elseif pd.buttonJustPressed(pd.kButtonRight) then
        if column < self.maxCol then
            self.gridview:selectNextColumn(true)
        end
    end

    if self.gridview.needsDisplay or forceRedrawGrid then
        local gridviewImage = gfx.image.new(self.gridWidth + self.edgePadding * 2, self.gridHeight + self.edgePadding * 2)
        gfx.pushContext(gridviewImage)
            self.gridview:drawInRect(0, 0, self.gridWidth + self.edgePadding * 2, self.gridHeight + self.edgePadding * 2)
        gfx.popContext()
        self:setImage(gridviewImage)
    end
end

function GardenGrid:getRandomGrowthTime()
    local minTime = 30
    local maxTime = 60
    local elapsedSeconds = pd.getElapsedTime()
    return elapsedSeconds + math.random(minTime, maxTime)
end

function GardenGrid:updatePlants()
    local hasUpdated = false
    local elapsedSeconds = pd.getElapsedTime()
    for i=self.minRow, self.maxRow do
        for j=self.minCol, self.maxCol do
            local plotData = GARDEN_DATA[i][j]
            if plotData then
                if not plotData.grown and (elapsedSeconds >= plotData.growTime) then
                    GARDEN_DATA[i][j].grown = true
                    hasUpdated = true
                end
            end
        end
    end
    return hasUpdated
end