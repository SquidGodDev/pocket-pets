
local pd <const> = playdate
local gfx <const> = pd.graphics

class('Button').extends(gfx.sprite)

function Button:init(x, y, foodList, petList, buttonImageTable)
    self.foodList = foodList
    self.petList = petList
    self.buttonImageTable = buttonImageTable
    self:setImage(self.buttonImageTable:getImage(1))
    self.selected = false
    self:moveTo(x, y)
    self:add()

    self.buttonSound = pd.sound.sampleplayer.new("sound/UI/click")
end

function Button:update()
    local listOut = false
    if self.foodList and self.foodList.listOut then
        listOut = true
    elseif self.petList and self.petList.listOut then
        listOut = true
    end
    if self.selected and not listOut then
        if pd.buttonJustPressed(pd.kButtonA) then
            self:pressButton()
            self.buttonSound:play()
        end

        if pd.buttonIsPressed(pd.kButtonA) then
            self:setImage(self.buttonImageTable:getImage(2))
        else
            self:setImage(self.buttonImageTable:getImage(1))
        end
    end
end

function Button:select(flag)
    self.selected = flag
    if not flag then
        self:setImage(self.buttonImageTable:getImage(1))
    end
end

function Button:pressButton()
   -- Override
end