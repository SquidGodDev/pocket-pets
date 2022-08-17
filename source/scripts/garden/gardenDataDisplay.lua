local pd <const> = playdate
local gfx <const> = pd.graphics

class('GardenDataDisplay').extends(Button)

function GardenDataDisplay:init(seedList, gardenGrid)
    self.seedList = seedList
    self.gardenGrid = gardenGrid
    self.textHeight = 2
    self:setCenter(0, 0)
    self:moveTo(30, 0)
    self:add()
    self:updateDisplay()

    Signals:subscribe("updateGardenDisplay", self, function()
        self:updateDisplay()
    end)
end

function GardenDataDisplay:update()
    
end

function GardenDataDisplay:updateDisplay()
    local displayImage = gfx.image.new("images/garden/gardenDataBackground")
    gfx.pushContext(displayImage)
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        gfx.drawText("Plot: ", 13, self.textHeight)
        local selectedPlotData = self.gardenGrid:getSelectedPlot()
        if not selectedPlotData then
            gfx.drawText("empty", 56, self.textHeight)
        else
            gfx.setImageDrawMode(gfx.kDrawModeCopy)
            local plantImage = self:getPlantImage(selectedPlotData.plant)
            plantImage:draw(73, self.textHeight)
        end
        gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
        local selectedPlant = self.seedList:getSelectedPlant()
        local selectedPlantData = PLANT_INVENTORY[selectedPlant]
        gfx.drawText("Selected: ", 132, self.textHeight)
        gfx.drawText(selectedPlantData.seeds, 247, self.textHeight)
        gfx.drawText(selectedPlantData.plant, 308, self.textHeight)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        local seedImage = gfx.image.new("images/garden/plants/seeds")
        seedImage:draw(220, self.textHeight)
        local plantImage = self:getPlantImage(selectedPlant)
        plantImage:draw(284, self.textHeight)
    gfx.popContext()
    self:setImage(displayImage)
end

function GardenDataDisplay:getPlantImage(plantName)
    return gfx.image.new("images/garden/plants/" .. plantName)
end