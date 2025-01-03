# Pocket Pets!
Source code for my Playdate game "Pocket Pets!", a Tamagotchi inspired virtual pet game. Tend to your garden, card for your pet's hunger/happiness, play mini games like a fishing mini game and a Mega Man Battle Network inspired game, and more! You can find the game on [Itch IO](https://squidgod.itch.io/pocket-pets).

<img src="https://github.com/user-attachments/assets/831847a3-042b-4586-9931-7ca321fef9d9" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/d7085ddf-896b-4b6e-88d3-39e1cfab00dc" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/866d7cfc-5429-4a9b-85ee-9520cecb68c8" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/dbb05496-3294-4dc3-8c80-83a2bf37fca0" width="400" height="240"/>

## Project Structure
- `scripts/`
    - `battle/`
        - `battleScene.lua` - The scene for the grid battler mini-game. Check this file for more details on the other files.
    - `fishing/`
        - `fishingScene.lua` - The scene for the fishing mini-game. Check this file for more details on the other files.
    - `garden/`
        - `gardenScene.lua` - The scene for the garden. Check this file for more details on the other files.
    - `home/`
        - `homeScene.lua` - The scene for the main home screen. Check this file for more details on the other files.
    - `libraries/`
        - `AnimatedSprite.lua` - A library from Whitebrim that handles the animations for the pet in the home screen.
        - `Sequence.lua` - A library from Nic Magnier that let's you string together animations. I just used it for the pet hatching scene.
        - `Signal.lua` - A library from Dustin Mierau that allows you to send signals throughout your game that I used for miscellaneous data transfer.
        - `Utilities.lua` - A library of utility functions that I'm building up. It only has one function in it right now 😅
    - `manual/`
        - `manualScene.lua` - The scene that handles drawing the QR code that links to the manual.
    - `petHatch/`
        - `petHatchScene.lua` - The scene that handles hatching a new pet.
    - `petList/`
        - `petListScene.lua` - The scene where you can see what pets you have and can switch them out.
    - `shop/`
        - `shopScene.lua` - The vending machine shop scene.
    - `wish/`
        - `wishScene.lua` - The daily wish scene.
    - `dataStore.lua` - Contains all the data that the game stores and handles saving and loading that data.
    - `globals.lua` - A couple global functions (checking for daytime and also getting the corresponding pet image tables)
    - `sceneManager.lua` - Manages switching between scenes

## License
All code is licensed under the terms of the MIT license, with the exception of `Signal.lua` by Dustin Mierau.
