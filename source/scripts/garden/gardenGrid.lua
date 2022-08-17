local pd <const> = playdate
local gfx <const> = pd.graphics

class('GardenGrid').extends(gfx.sprite)

function GardenGrid:init(minRow, maxRow, minCol, maxCol)
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
    end

    self:setCenter(0, 0)
    self:moveTo(21 - self.edgePadding / 2, 10 - self.edgePadding / 2)
    self:add()
end

function GardenGrid:update()
    local _, row, column = self.gridview:getSelection()
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
    if self.gridview.needsDisplay then
        local gridviewImage = gfx.image.new(self.gridWidth + self.edgePadding * 2, self.gridHeight + self.edgePadding * 2)
        gfx.pushContext(gridviewImage)
            self.gridview:drawInRect(0, 0, self.gridWidth + self.edgePadding * 2, self.gridHeight + self.edgePadding * 2)
        gfx.popContext()
        self:setImage(gridviewImage)
    end
end
