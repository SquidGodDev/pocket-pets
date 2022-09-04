import "scripts/libraries/Utilities"
import "scripts/home/homeScene"

local pd <const> = playdate
local gfx <const> = pd.graphics

local util <const> = utilities

class('ManualScene').extends(gfx.sprite)

function ManualScene:init()
    local manualQR = gfx.image.new("images/manual/manualQR")
    self:setImage(manualQR)
    self:moveTo(200, 90)
    self:add()

    local descriptionText = "Scan to open gameplay manual"
    local descriptionTextSprite = util.centeredTextSprite(descriptionText)
    descriptionTextSprite:moveTo(200, 180)
    descriptionTextSprite:add()

    local urlText = "Also linked on squidgod.itch.io/pocket-pets"
    local urlTextSprite = util.centeredTextSprite(urlText)
    urlTextSprite:moveTo(200, 220)
    urlTextSprite:add()
end

function ManualScene:update()
    if pd.buttonJustPressed(pd.kButtonB) then
        SceneManager:switchScene(HomeScene)
    end
end