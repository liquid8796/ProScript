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
local team = require "Scripts/Libs/teamlib"
```

## Kanto mount behavior

Kanto training scripts no longer configure mounts during `onStart()` from city, Pokecenter, or travel-only maps. Shared Kanto scripts call `team.setMountForTrainingMap()` from `onPathAction()`, and the helper only calls `setMount(...)` when the current map is a known training map such as Route/Viridian Forest/Rock Tunnel/Seafoam/Victory Road. Intermediate maps and city maps are skipped.
