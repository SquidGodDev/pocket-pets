import "scripts/home/homeScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('PetListScene').extends(gfx.sprite)

function PetListScene:init()
    local backgroundImage = gfx.image.new("images/petList/petListBackground")
    self:setImage(backgroundImage)
    self:moveTo(200, 120)
    self:add()

    self.petList = pd.ui.gridview.new(122, 33)
    self.petList:setContentInset(3, 3, 0, 0)
    self.listWidth = 130
    self.listHeight = 212

    self.listSprite = gfx.sprite.new(self.listWidth, self.listHeight)
    self.listSprite:setCenter(0, 0)
    self.listSprite:moveTo(6, 12)
    self.listSprite:add()

    self.rowToPet = {}
    local rowCount = 1
    for petName,_ in pairs(PETS) do
        self.rowToPet[rowCount] = petName
        if SELECTED_PET == petName then
            self.petList:setSelectedRow(rowCount)
        end
        rowCount += 1
    end

    self.petList:setNumberOfRows(#self.rowToPet)

    self.petListObject = getmetatable(self.petList)
    self.petListObject.selectorImage = gfx.image.new("images/petList/petListSelector")
    self.petListObject.listItemOffset = 7
    self.petListObject.listItemWidth = 110
    self.petListObject.listItemHeight = 21
    self.petListObject.rowToPet = self.rowToPet

    function self.petList:drawCell(section, row, column, selected, x, y, width, height)
        if selected then
            self.selectorImage:draw(x, y)
        end
        gfx.setColor(gfx.kColorWhite)
        gfx.fillRoundRect(x + self.listItemOffset, y + self.listItemOffset, self.listItemWidth, self.listItemHeight, 3)
        gfx.drawTextAligned(self.rowToPet[row], x + width / 2, y + (height - 16) / 2, kTextAlignment.center)
    end

    self.petInfoWidth = 220
    self.petInfoHeight = 191
    self.petInfoSprite = gfx.sprite.new()
    self.petInfoSprite:setCenter(0, 0)
    self.petInfoSprite:moveTo(165, 23)
    self.petInfoSprite:add()

    self.clickSound = pd.sound.sampleplayer.new("sound/UI/click")
end

function PetListScene:update()
    if pd.buttonJustPressed(pd.kButtonB) then
        SceneManager:switchScene(HomeScene)
    elseif pd.buttonJustPressed(pd.kButtonA) then
        SELECTED_PET = self:getSelectedPet()
        SceneManager:switchScene(HomeScene)
    end

    local crankTicks = pd.getCrankTicks(4)
    if pd.buttonJustPressed(pd.kButtonDown) or crankTicks == 1 then
        self.clickSound:play()
        self.petList:selectNextRow(true)
    elseif pd.buttonJustPressed(pd.kButtonUp) or crankTicks == -1 then
        self.clickSound:play()
        self.petList:selectPreviousRow(true)
    end

    if self.petList.needsDisplay then
        local petListImage = gfx.image.new(self.listWidth, self.listHeight)
        gfx.pushContext(petListImage)
            self.petList:drawInRect(0, 0, self.listWidth, self.listHeight)
        gfx.popContext()
        self.listSprite:setImage(petListImage)
        self:drawPetInfo()
    end
end

function PetListScene:drawPetInfo()
    local petInfoImage = gfx.image.new(self.petInfoWidth, self.petInfoHeight)
    gfx.pushContext(petInfoImage)
        local selectedPet = self:getSelectedPet()
        local petImageTable = GET_PET_IMAGETABLE(selectedPet)
        local petImage = petImageTable:getImage(1)
        petImage:draw(95, 12)
        gfx.drawTextAligned("*"..selectedPet.."*", self.petInfoWidth / 2, 60, kTextAlignment.center)
        local plantDeck = PETS[selectedPet].plantDeck
        local baseX, baseY = 16, 98
        local gapX, gapY = 39, 47
        for index, plant in ipairs(plantDeck) do
            local drawY = baseY
            if index > 5 then
                index -= 5
                drawY += gapY
            end
            local drawX = baseX + (index - 1) * gapX
            local plantImage = gfx.image.new("images/garden/plants/" .. plant):scaledImage(2):invertedImage()
            plantImage:draw(drawX, drawY)
        end
    gfx.popContext()
    self.petInfoSprite:setImage(petInfoImage)
end

function PetListScene:getSelectedPet()
    local _, row = self.petList:getSelection()
    return self.rowToPet[row]
end