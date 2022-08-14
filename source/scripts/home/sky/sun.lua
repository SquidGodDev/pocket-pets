import "scripts/globals"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('Sun').extends(gfx.sprite)

function Sun:init(x, y)
    local sunImage = gfx.image.new("images/mainScreen/sun")
    local moonImage = gfx.image.new("images/mainScreen/moon")

    if IS_DAYTIME() then
        self:setImage(sunImage)
    else
        self:setImage(moonImage)
    end
    self:moveTo(x, y)
    self:add()

    local bobAmount = 15
    self.bobAnimator = gfx.animator.new(2000, y, y + bobAmount, pd.easingFunctions.linear)
    self.bobAnimator.reverses = true
    self.bobAnimator.repeatCount = -1
end

function Sun:update()
    -- self:moveTo(self.x, self.bobAnimator:currentValue())
end