
local pd <const> = playdate
local gfx <const> = pd.graphics

class('Button').extends(gfx.sprite)

function Button:init(x, y, buttonImageTable)
    self.buttonImageTable = buttonImageTable
    self:setImage(self.buttonImageTable:getImage(1))
    self.selected = false
    self:moveTo(x, y)
    self:add()
end

function Button:update()
    if self.selected then
        if pd.buttonJustPressed(pd.kButtonA) then
            self:pressButton()
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