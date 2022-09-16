-- This is the system that I use for creating the listviews. I basically copy pasted the code
-- for the feeding list and also the game list, and I really should've created a more generic
-- approach that I could reuse, but who knew I would use it again!!

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
    for _,v in ipairs(PLANTS_IN_ORDER) do
        self.rowToPlant[rowCount] = v
        rowCount += 1
    end
    self.listview:setNumberOfRows(#self.rowToPlant)
    self.listviewObject.rowToPlant = self.rowToPlant

    self.listviewObject.selectImage = gfx.image.new("images/garden/seedListSelector")

    -- This part is pretty important. I pre-render all the image and then cache them,
    -- so I don't have to continously make a disk access to get the images. If you don't
    -- do this and create the images in the drawCell callback, then it lags the crap
    -- out of your list
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
        local plantSeedCount = PLANT_INVENTORY[plantName].seeds
        gfx.drawText(plantSeedCount, x + 37, y + yOffset)
    end

    self.listOut = false

    self.listX = 304
    self:setCenter(0, 0)
    self:moveTo(400, 0)
    self:setZIndex(100)
    self:add()

    self.clickSound = pd.sound.sampleplayer.new("sound/UI/mouseClick")
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
        if crankTicks == -1 or pd.buttonJustPressed(pd.kButtonUp) then
            self.clickSound:play()
            self.listview:selectPreviousRow(true)
            Signals:notify("updateGardenDisplay")
        elseif crankTicks == 1 or pd.buttonJustPressed(pd.kButtonDown) then
            self.clickSound:play()
            self.listview:selectNextRow(true)
            Signals:notify("updateGardenDisplay")
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
    return btnPress(pd.kButtonLeft) or btnPress(pd.kButtonRight) or btnPress(pd.kButtonA) or btnPress(pd.kButtonB)
end