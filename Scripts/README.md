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

Kanto training scripts configure automatic ground mounts on non-training travel maps, such as cities, Pokecenters, and transit maps. On Kanto training/encounter maps such as Route 2, Viridian Forest, Rock Tunnel, Seafoam, and Victory Road, ground mounts are disabled by default: the helper clears the configured ground mount and calls `disMount()` when the player is already mounted so the bot does not enter grass/cave training while mounted.

The shared Kanto `teamlib.lua` exposes script option 6 named `Use mount for train`. When this option is enabled, Kanto training/encounter maps also configure the first available ground mount from `Scripts/Libs/mountList.lua`. When it is disabled, training/encounter maps keep the safer no-mount behavior. The standalone `Seafoam B4F.lua` script exposes the same toggle as option 1.

`team.setMountForTrainingMap()` returns `true` only when it actually sends `disMount()` and the current tick should wait. Configuring mounts with `setMount(mount)` and clearing mount configuration with `setMount("")` are not considered Lua movement/actions, so the script continues to execute its normal path logic in the same tick.


## MoonSharp require path note

PROCatchem resolves Lua `require` paths relative to the folder of the selected script.
For Kanto scripts under `Scripts/Kanto/<Category>/`, use:

```lua
local team = require "../../Libs/teamlib"
```

Inside `teamlib.lua`, the related shared data files are required with the same `../../Libs/...` path so Kanto Capture, EV Training, and Leveling scripts can load them consistently.

## Kanto battle catch safety

`Scripts/Libs/teamlib.lua` includes a catch-stuck guard for `Only search` hunting. If the script tries to weaken the same wild Pokémon several times without lowering its HP, or if no weakening move can be used, the helper throws a ball instead of repeatedly returning no battle action. This avoids cases such as repeated `Weakening <pokemon> before catch` logs followed by the bot stopping.

### Kanto shared teamlib: Auto buy pokeball

Kanto scripts that use `Scripts/Libs/teamlib.lua` now expose option 7: `Auto buy pokeball`.
When enabled, the helper checks at the start of `onPathAction()` through `team.setMountForTrainingMap()`.
If the inventory has 0 `Pokeball` and money is at least `$30000`, the script routes toward a known Kanto Pokemart and buys up to 150 Pokeballs.

Rules:
- The toggle is OFF by default.
- It only triggers when `getItemQuantity("Pokeball") == 0` and `getMoney() >= 30000`.
- Buying uses `buyItem("Pokeball", amount)` with a target stock of 150.
- The helper returns `true` only when it performs a path/shop/leave-mart action, so the current tick waits safely.
- After buying, the helper leaves the Pokemart before normal script pathing resumes, avoiding `No action executed` inside shop maps.

## Kanto Only search non-target behavior

When option 3 `Only search` is enabled, Kanto teamlib now only throws balls for Pokémon that match the hunt list or shiny condition. Wild Pokémon that do not match the target condition are defeated with `attack()` / `useAnyMove()` instead of using `run()`. This keeps battles deterministic and avoids the old behavior where non-target encounters were immediately escaped.


## Kanto Mt. Moon target list update

`Scripts/Libs/listPokemon.lua` now includes Mt. Moon wild Pokémon from the PRO Wiki `Mt. Moon` page, covering 1F, B1F, and B2F Land encounters plus Diggable Patches. Existing target counters are preserved; newly added species default to `0`.
