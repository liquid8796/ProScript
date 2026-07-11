# ProScript

Lua scripts for PROCatchem. The main questing bootstrap is `BetterQuesting.lua`.

## Run BetterQuesting

In PROCatchem, open **Script**, choose **Load Script**, then select `BetterQuesting.lua` from the root of this package.

## BetterQuesting options

1. **Pokemart** — allows the quest script to visit a Pokemart and buy Poké Balls when its configured conditions are met.
2. **Catch mode** — enables catching eligible wild, shiny, event, uncaught, or quest-related Pokémon.
3. **Evolve** — enables the quest evolution logic, including supported Moon Stone evolutions.
4. **Check Best Pkm** — enables selected quest checkpoints to inspect PC storage and replace team members with species having a higher configured `TotalStats` value. It compares species base-stat totals only; it does not evaluate IVs, EVs, Nature, level, moves, or Ability.

## Changes

- Removed the `Relog on stop` option and its `onStop()` relog behavior.
- Renumbered the remaining BetterQuesting options from 1 through 4.
- Updated all BetterQuesting quest references to the new option indices.

- Audited `talkToNpcOnCell(...)` coordinates against the supplied `maps.zip` using PROCatchem's map parser.
- Corrected confirmed NPC/object positions on `Viridian Maze`, `Bills House`, `Pokemon Tower 6F`, and `Indigo Plateau`.
- Kept coordinates unchanged where the corresponding map file was not present in `maps.zip`; those maps are listed in the separately generated audit report.
