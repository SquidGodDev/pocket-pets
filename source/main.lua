
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/ui"
import "CoreLibs/animator"

import "scripts/home/homeScene"
import "scripts/garden/gardenScene"

import "scripts/sceneManager"
import "scripts/libraries/Signal"

import "scripts/datastore"

local pd <const> = playdate
local gfx <const> = pd.graphics

math.randomseed(pd.getSecondsSinceEpoch())

CUR_TIME = pd.getTime()

SceneManager = SceneManager()
Signals = Signal()

HomeScene()
-- GardenScene()

function pd.update()
    CUR_TIME = pd.getTime()
    gfx.sprite.update()
    pd.timer.updateTimers()
    SceneManager:update()
end
