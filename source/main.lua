
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/ui"
import "CoreLibs/animator"
import "CoreLibs/animation"
import "CoreLibs/keyboard"
import "CoreLibs/qrcode"

import "scripts/home/homeScene"
import "scripts/petHatch/petHatchScene"

import "scripts/sceneManager"
import "scripts/libraries/Signal"

import "scripts/datastore"

import "scripts/globals.lua"

local pd <const> = playdate
local gfx <const> = pd.graphics

math.randomseed(pd.getSecondsSinceEpoch())

SceneManager = SceneManager()
Signals = Signal()

if SELECTED_PET == "" then
    PetHatchScene()
else
    HomeScene()
end

BgMusic = pd.sound.sampleplayer.new("sound/endCreditsLofi")

BgMusic:play(0)

local menu = pd.getSystemMenu()

menu:addCheckmarkMenuItem("Music", true, function(flag)
    if flag then
        if not BgMusic:isPlaying() then
            BgMusic:play(0)
        end
    else
        BgMusic:stop()
    end
end)

function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    SceneManager:update()
end
