
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/ui"
import "CoreLibs/animator"
import "CoreLibs/animation"
import "CoreLibs/keyboard"

import "scripts/home/homeScene"
import "scripts/petHatch/petHatchScene"
import "scripts/battle/battleScene"

import "scripts/sceneManager"
import "scripts/libraries/Signal"

import "scripts/datastore"

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

BgMusic = pd.sound.sampleplayer.new("sound/cloud")
if IS_DAYTIME() then
    BgMusic = pd.sound.sampleplayer.new("sound/endCreditsLofi")
end

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
