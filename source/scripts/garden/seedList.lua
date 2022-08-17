local pd <const> = playdate
local gfx <const> = pd.graphics

class('SeedList').extends(gfx.sprite)

function SeedList:init()

    self.listview = pd.ui.gridview.new(78, 26)
    self.listview:setContentInset(0, 0, 0, 0)
    self.listview:setCellPadding(9, 9, 5, 5)
    self.listWidth = 96
    self.listHeight = 240

    self.listviewObject = getmetatable(self.listview)
    self.rowToPlant = {}
    local rowCount = 1
    for key in pairs(PLANT_INVENTORY) do
        self.rowToPlant[rowCount] = key
        rowCount += 1
    end
    self.listview:setNumberOfRows(#self.rowToPlant)
    self.listviewObject.rowToPlant = self.rowToPlant

    self.animationTime = 300

    function self.listview:drawCell(section, row, column, selected, x, y, width, height)
        if selected then
            local selectOffset = 5
            local selectImage = gfx.image.new("images/garden/seedListSelector")
            selectImage:draw(x - selectOffset, y - selectOffset)
        end
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(x, y, width, height, 3)
        gfx.setColor(gfx.kColorBlack)
        local yOffset = (height - 16)/2
        local plantName = self.rowToPlant[row]
        local plantImagePath = "images/garden/plants/" .. plantName
        local plantImage = gfx.image.new(plantImagePath)
        gfx.setImageDrawMode(gfx.kDrawModeInverted)
        plantImage:draw(x + 4, y + yOffset)
        gfx.setImageDrawMode(gfx.kDrawModeCopy)
        local plantSeedCount = PLANT_INVENTORY[plantName].seeds
        gfx.drawText(plantSeedCount, x + 37, y + yOffset)
    end

    self.listOut = true

    self.listX = 304
    self:setCenter(0, 0)
    self:moveTo(self.listX, 0)
    self:setZIndex(100)
    self:add()
end

function SeedList:update()
    if self.listAnimator then
        self:moveTo(self.listAnimator:currentValue(), self.y)
        if self.listAnimator:ended() then
            self.listAnimator = nil
        end
    end

    local crankTicks = pd.getCrankTicks(4)
    if self:navigationButtonPressed() and self.listOut then
        self:animateOffScreen()
        self.listOut = false
    elseif crankTicks ~= 0 and not self.listOut then
        self:animateOnScreen()
        self.listOut = true
    end

    if self.listOut then
        if crankTicks == -1 then
            self.listview:selectPreviousRow(true)
        elseif crankTicks == 1 then
            self.listview:selectNextRow(true)
        end
    end

    if self.listview.needsDisplay then
        local listviewImage = gfx.image.new(self.listWidth, self.listHeight, gfx.kColorBlack)
        gfx.pushContext(listviewImage)
            self.listview:drawInRect(0, 0, self.listWidth, self.listHeight)
        gfx.popContext()
        self:setImage(listviewImage)
    end
end

function SeedList:getSelectedPlant()
    local _, row = self.listview:getSelection()
    return self.rowToPlant[row]
end

function SeedList:animateOffScreen()
    local animateOffset = (1 - (400 - self.x) / (400 - self.listX)) * - self.animationTime
    self.listAnimator = gfx.animator.new(self.animationTime, self.x, self.listX + self.listWidth, pd.easingFunctions.inOutCubic, animateOffset)
end

function SeedList:animateOnScreen()
    local animateOffset = (400 - self.x) / (400 - self.listX) * - self.animationTime
    self.listAnimator = gfx.animator.new(self.animationTime, self.x, self.listX, pd.easingFunctions.inOutCubic, animateOffset)
end

function SeedList:navigationButtonPressed()
    local btnPress = pd.buttonJustPressed
    return btnPress(pd.kButtonDown) or btnPress(pd.kButtonUp) or btnPress(pd.kButtonLeft) or btnPress(pd.kButtonRight) or btnPress(pd.kButtonA)
end