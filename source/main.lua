--[[
Hey Giant Squid patrons! Now that I wrapped up this game, I've went ahead and added comments to the game. This is my biggest
project so far, so there's a lot to cover. I kind of rushed to finish this game, as the majority of the work was done over the
course of two weeks, so some parts are not pretty. 

Below is the overarching file structure for the project. In each main folder, I expound more on the sub-folders and files in
the scene files.

scripts/
    battle/
        battleScene.lua - The scene for the grid battler mini-game. Check this file for more details on the other files.
    fishing/
        fishingScene.lua - The scene for the fishing mini-game. Check this file for more details on the other files.
    garden/
        gardenScene.lua - The scene for the garden. Check this file for more details on the other files.
    home/
        homeScene.lua - The scene for the main home screen. Check this file for more details on the other files.
    libraries/
        AnimatedSprite.lua - A library from Whitebrim that handles the animations for the pet in the home screen.
        Sequence.lua - A library from Nic Magnier that let's you string together animations. I just used it for the pet hatching scene.
        Signal.lua - A library from Dustin Mierau that allows you to send signals throughout your game that I used for miscellaneous data transfer.
        Utilities.lua - A library of utility functions that I'm building up. It only has one function in it right now 😅
    manual/
        manualScene.lua - The scene that handles drawing the QR code that links to the manual.
    petHatch/
        petHatchScene.lua - The scene that handles hatching a new pet.
    petList/
        petListScene.lua - The scene where you can see what pets you have and can switch them out.
    shop/
        shopScene.lua - The vending machine shop scene.
    wish/
        wishScene.lua - The daily wish scene.
    dataStore.lua - Contains all the data that the game stores and handles saving and loading that data.
    globals.lua - A couple global functions (checking for daytime and also getting the corresponding pet image tables)
    sceneManager.lua - Manages switching between scenes (I have a tutorial on this coming out this week)
]]--


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

-- Seeding randomness so we get different random values
math.randomseed(pd.getSecondsSinceEpoch())

-- Initializing SceneManager as basically a global singleton. This is an older version of my
-- scene manager, which require's calling it in the update method. Check out my tutorial for
-- an updated version
SceneManager = SceneManager()

-- This is a signal library from Dustin Mierau that allows you to send signals and data across
-- the project without a direct connection, which is quite useful. It's kind of like signals in Godot
Signals = Signal()

-- When you first start the game, you won't have a pet, so there's no selected pet. In that case, I
-- immediately load into the pet hatching scene. Otherwise, we go to the home screen.
if SELECTED_PET == "" then
    PetHatchScene()
else
    HomeScene()
end

-- Here's a kind of jank background music system that allows me to start and stop the background music
-- using a system menu option. Next time, I'll probably adjust the volume instead, since there's kind of
-- an issue if you have two or more different background songs, like for the battle vs the default song
BgMusic = pd.sound.sampleplayer.new("sound/endCreditsLofi")

BgMusic:play(0)

-- Here's how you add a system menu option. It's documented decently in the sdk documentation
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
    -- Here's the scene manager update I mentioned before. This is not necessary in
    -- the updated version
    SceneManager:update()
end
