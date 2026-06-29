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
