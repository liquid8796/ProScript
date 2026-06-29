# PROShine-Scripts

Default and minimalist scripts for PROShine, released under the WTFPL version 2 public license.

## Kanto shared libraries

Kanto leveling shared files have been moved out of `Scripts/Kanto/Leveling` into `Scripts/Libs`:

- `Scripts/Libs/teamlib.lua`
- `Scripts/Libs/listPokemon.lua`
- `Scripts/Libs/listEVs.lua`
- `Scripts/Libs/mountList.lua`

Kanto scripts should now import the shared team helper with:

```lua
local team = require "../../Libs/teamlib"
```

## Kanto mount behavior

Kanto training scripts no longer configure automatic ground mounts while walking through city/Pokecenter/transit maps or while training on encounter maps. Shared Kanto scripts call `team.setMountForTrainingMap()` from `onPathAction()`, and the helper now clears the configured ground mount on training maps such as Route 2, Viridian Forest, Rock Tunnel, Seafoam, and Victory Road so the bot does not enter grass/cave training while mounted.

`team.setMountForTrainingMap()` returns `true` only when it actually sends `disMount()` and the current tick should wait. Clearing mount configuration with `setMount("")` is not considered a Lua movement/action, so the script continues to execute its normal path logic in the same tick.


## MoonSharp require path note

PROCatchem resolves Lua `require` paths relative to the folder of the selected script.
For Kanto scripts under `Scripts/Kanto/<Category>/`, use:

```lua
local team = require "../../Libs/teamlib"
```

Inside `teamlib.lua`, the related shared data files are required with the same `../../Libs/...` path so Kanto Capture, EV Training, and Leveling scripts can load them consistently.
