# Pocket Pets!
Source code for my Playdate game "Pocket Pets!", a Tamagotchi inspired virtual pet game. Tend to your garden, card for your pet's hunger/happiness, play mini games like a fishing mini game and a Mega Man Battle Network inspired game, and more! You can find the game on [Itch IO](https://squidgod.itch.io/pocket-pets).

<img src="https://github.com/user-attachments/assets/831847a3-042b-4586-9931-7ca321fef9d9" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/d7085ddf-896b-4b6e-88d3-39e1cfab00dc" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/866d7cfc-5429-4a9b-85ee-9520cecb68c8" width="400" height="240"/>
<img src="https://github.com/user-attachments/assets/dbb05496-3294-4dc3-8c80-83a2bf37fca0" width="400" height="240"/>

## Project Structure
- `scripts/`
    - `battle/`
        - `enemies/`
            - `baseEnemy.lua` - The base enemy class that allows me to easily create different enemies by extending it
        - `battleScene.lua` - The scene for the grid battler mini-game
        - `playerAttackSprite.lua` - A small helper sprite that displays the slashing attack animation
        - `warningIcon.lua` - A small helper sprite that displays the warning icon
    - `fishing/`
        - `fishingPet.lua` - The code for your pet walking around in the fishing mini-game
        - `fishingScene.lua` - The scene for the fishing mini-game
    - `garden/`
        - `gardenDataDisplay.lua` - UI for the garden info at the top of the scene
        - `gardenGrid.lua` - Draws the actual garden grid, seeds, and plants
        - `gardenScene.lua` - The scene for the garden
        - `seedList.lua` - Handles the seed list on the side
    - `home/`
        - `buttons/`
            - `button.lua` - The base button class to handle the buttons
        - `food/`
            - `foodList.lua` - Handles the list drawing for the food - it's basically the same as `seedList.lua` and `gameList.lua`
        - `games/`
            - `gameList.lua` - Handles the list for the available mini-games - it's basically the same as `seedList.lua` and `foodList.lua`
        - `pets/`
            - `pet.lua` - The base pet class that handles drawing the pet on the home screen and having them wander around - all the other pet files aren't actually used at all, so they should've been deleted
        - `sky/`
            - `cloudBanner.lua` - Old code that handled moving clouds - not used anymore
            - `clouds.lua` - Also not used and should've been deleted
            - `sky.lua` - Just draws the night sky
            - `sun.lua` - Just handles drawing the sun or moon depending on the time of day
        - `homeButtons.lua` - Handles the buttons on the home scene
        - `homeScene.lua` - The scene for the main home screen
        - `statsUI.lua` - Handles the pet stats on the top left
    - `libraries/`
        - `AnimatedSprite.lua` - A library from Whitebrim that handles the animations for the pet in the home screen
        - `Sequence.lua` - A library from Nic Magnier that let's you string together animations - I just used it for the pet hatching scene
        - `Signal.lua` - A library from Dustin Mierau that allows you to send signals throughout your game that I used for miscellaneous data transfer
        - `Utilities.lua` - A library of utility functions that I'm building up - it only has one function in it right now...
    - `manual/`
        - `manualScene.lua` - The scene that handles drawing the QR code that links to the manual
    - `petHatch/`
        - `petHatchScene.lua` - The scene that handles hatching a new pet
    - `petList/`
        - `petListScene.lua` - The scene where you can see what pets you have and can switch them out
    - `shop/`
        - `shopScene.lua` - The vending machine shop scene
    - `wish/`
        - `wishScene.lua` - The daily wish scene
    - `dataStore.lua` - Contains all the data that the game stores and handles saving and loading that data
    - `globals.lua` - A couple global functions (checking for daytime and also getting the corresponding pet image tables)
    - `sceneManager.lua` - Manages switching between scenes

## License
All code is licensed under the terms of the MIT license, with the exception of `Signal.lua` by Dustin Mierau.
