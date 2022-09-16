-- Pretty much the same as seedList.lua. Check that file for more details

local pd <const> = playdate
local gfx <const> = pd.graphics

class('FoodList').extends(gfx.sprite)

function FoodList:init()
    Signals:subscribe("openFoodList", self, function()
        self:openList()
    end)
    self.listview = pd.ui.gridview.new(78, 26)
    self.listview:setContentInset(0, 0, 0, 0)
    self.listview:setCellPadding(9, 9, 5, 5)
    self.listWidth = 96
    self.listHeight = 240

    self.listviewObject = getmetatable(self.listview)
    self.rowToPlant = {}
    local rowCount = 1
    for _,plant in ipairs(PLANTS_IN_ORDER) do
        self.rowToPlant[rowCount] = plant
        rowCount += 1
    end
    self.listview:setNumberOfRows(#self.rowToPlant)
    self.listviewObject.rowToPlant = self.rowToPlant

    self.listviewObject.selectImage = gfx.image.new("images/garden/seedListSelector")

    local plantImages = {}
    for _, plantName in ipairs(PLANTS_IN_ORDER) do
        local plantImage = gfx.image.new("images/garden/plants/" .. plantName)
        plantImages[plantName] = plantImage
    end
    self.listviewObject.plantImages = plantImages

    self.animationTime = 300

    function self.listview:drawCell(section, row, column, selected, x, y, width, height)
        if selected then
            local selectOffset = 5
            self.selectImage:draw(x - selectOffset, y - selectOffset)
        end
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(x, y, width, height, 3)
        gfx.setColor(gfx.kColorBlack)
        local yOffset = (height - 16)/2
        local plantName = self.rowToPlant[row]
        local plantImage = self.plantImages[plantName]
        gfx.setImageDrawMode(gfx.kDrawModeInverted)
        plantImage:draw(x + 4, y + yOffset)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        local plantSeedCount = PLANT_INVENTORY[plantName].plant
        gfx.drawText(plantSeedCount, x + 45, y + yOffset)
    end

    self.listOut = false

    self.listX = 304
    self:setCenter(0, 0)
    self:moveTo(400, 0)
    self:setZIndex(500)

    self.eatSound = pd.sound.sampleplayer.new("sound/home/chomp")
    self.slideSound = pd.sound.sampleplayer.new("sound/UI/transitionWhoosh")
    self.clickSound = pd.sound.sampleplayer.new("sound/UI/mouseClick")
end

function FoodList:update()
    if self.listAnimator then
        self:moveTo(self.listAnimator:currentValue(), self.y)
        if self.listAnimator:ended() then
            self.listAnimator = nil
            if not self.listOut then
                self:remove()
            end
        end
    end

    if self:navigationButtonPressed() and self.listOut then
        self.slideSound:play()
        self:animateOffScreen()
        self.listOut = false
    end

    local forceUpdate = false
    if pd.buttonJustPressed(pd.kButtonA) then
        local selectedPlant = self:getSelectedPlant()
        local plantCount = PLANT_INVENTORY[selectedPlant].plant
        if plantCount > 0 then
            self.eatSound:play()
            Signals:notify("feed", 10)
            Signals:notify("happy")
            PLANT_INVENTORY[selectedPlant].plant -= 1
            forceUpdate = true
            self:addPlantToDeck(selectedPlant)
        end
    end

    if self.listOut then
        local crankTicks = pd.getCrankTicks(4)
        if crankTicks == -1 or pd.buttonJustPressed(pd.kButtonUp) then
            self.clickSound:play()
            self.listview:selectPreviousRow(true)
        elseif crankTicks == 1 or pd.buttonJustPressed(pd.kButtonDown) then
            self.clickSound:play()
            self.listview:selectNextRow(true)
        end
    end

    if self.listview.needsDisplay or forceUpdate then
        local listviewImage = gfx.image.new(self.listWidth, self.listHeight, gfx.kColorBlack)
        gfx.pushContext(listviewImage)
            self.listview:drawInRect(0, 0, self.listWidth, self.listHeight)
        gfx.popContext()
        self:setImage(listviewImage)
    end
end

function FoodList:addPlantToDeck(plant)
    local plantDeck = PETS[SELECTED_PET].plantDeck
    table.insert(plantDeck, plant)
    while #plantDeck > 10 do
        table.remove(plantDeck, 1)
    end
    PETS[SELECTED_PET].plantDeck = plantDeck
end


function FoodList:openList()
    if not self.listOut then
        self.slideSound:play()
        self:add()
        self:animateOnScreen()
        self.listOut = true
    end
end

function FoodList:getSelectedPlant()
    local _, row = self.listview:getSelection()
    return self.rowToPlant[row]
end

function FoodList:animateOffScreen()
    local animateOffset = (1 - (400 - self.x) / (400 - self.listX)) * - self.animationTime
    self.listAnimator = gfx.animator.new(self.animationTime, self.x, self.listX + self.listWidth, pd.easingFunctions.inOutCubic, animateOffset)
end

function FoodList:animateOnScreen()
    local animateOffset = (400 - self.x) / (400 - self.listX) * - self.animationTime
    self.listAnimator = gfx.animator.new(self.animationTime, self.x, self.listX, pd.easingFunctions.inOutCubic, animateOffset)
end

function FoodList:navigationButtonPressed()
    local btnPress = pd.buttonJustPressed
    return btnPress(pd.kButtonLeft) or btnPress(pd.kButtonRight) or btnPress(pd.kButtonB)
end