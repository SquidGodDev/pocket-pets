import "scripts/home/statsUI"
import "scripts/home/homeButtons"
import "scripts/home/sky/sky"
import "scripts/home/pets/buffBunny"
import "scripts/home/pets/crab"
import "scripts/home/pets/wingedUnicorn"
import "scripts/home/pets/dog"
import "scripts/home/pets/chicken"
import "scripts/home/pets/duck"
import "scripts/home/pets/cat"
import "scripts/home/pets/bat"
import "scripts/home/pets/snake"
import "scripts/home/pets/whale"

local pd <const> = playdate
local gfx <const> = pd.graphics

class('HomeScene').extends(gfx.sprite)

function HomeScene:init()
    Sky()
    local background = gfx.image.new("images/mainScreen/background")
    self:moveTo(200, 120)
    self:setImage(background)
    self:add()
    StatsUI(5, 5)
    HomeButtons()
    -- BuffBunny(30, 159)
    -- Crab(60, 159)
    -- WingedUnicorn(90, 159)
    Dog(120, 159)
    -- Chicken(150, 159)
    -- Duck(180, 159)
    -- Cat(210, 159)
    -- Bat(240, 159)
    -- Snake(270, 159)
    -- Whale(300, 159)
end