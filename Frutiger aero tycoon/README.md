# Frutiger Aero Tycoon Script

A Roblox Luau script with a Kavo UI for automating selected Frutiger Aero Tycoon tasks.

## Features

### Auto Farms

- **Auto Rebirth** — checks once per second whether the player's money meets the calculated rebirth price and requests a rebirth when affordable.
- **Auto Obby** — teleports the character to the obby button, then back to the tycoon's return point. The script waits 3.5 seconds at the obby and 60 seconds before repeating.
- **Auto Buy** — checks visible tycoon buttons and teleports the character to buttons whose price the player can afford.
- **Auto Buy Cooldown** — slider for the Auto Buy check interval, from 0.1 to 3 seconds.

### Misc

- **Anti AFK** — responds to the player's idle event while enabled.
- **Disable 3D Rendering** — disables 3D rendering while enabled and restores it when disabled.
- **All Badges** — searches Workspace descendants for names matching `BadgeGiver` followed by digits, teleports the character to each match with a one-second pause, then returns to the tycoon. Visiting a giver does not guarantee that the game awards its badge.

## Requirements and notes

- The script expects the game to provide the tycoon objects and values it uses, such as `Workspace.Plots`, `TempValues.Plot`, `leaderstats`, and the rebirth remote event.
- It loads Kavo UI from the repository URL in the script. The execution environment must support the APIs used by the script, including `loadstring` and `game:HttpGet`.
- Game updates or differences in object names and layout may make individual features stop working.

## Run Code (lazy people)
- loadstring(game:HttpGet("https://raw.githubusercontent.com/SpajroTheWolf/Roblox-Scripts/refs/heads/main/Frutiger%20aero%20tycoon/Frutiger%20aero%20tycoon.lua"))()

## Extras
Feel free to add stuff. Just credit me
