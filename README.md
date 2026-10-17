# ProScript

Lua scripts for PROCatchem. The main questing bootstrap is `BetterQuesting.lua`.

## Run BetterQuesting

In PROCatchem, open **Script**, choose **Load Script**, then select `BetterQuesting.lua` from the root of this package.

## BetterQuesting options

1. **Pokemart** — allows the quest script to visit a Pokemart and buy Poké Balls when its configured conditions are met.
2. **Catch mode** — enables catching eligible wild, shiny, event, uncaught, or quest-related Pokémon.
3. **Evolve** — enables the quest evolution logic, including supported Moon Stone evolutions.
4. **Check Best Pkm** — enables selected quest checkpoints to inspect PC storage and replace team members with species having a higher configured `TotalStats` value. It compares species base-stat totals only; it does not evaluate IVs, EVs, Nature, level, moves, or Ability.


## Kanto Route 10 / Rock Tunnel leveling (script v1.0.373)

The leveling script at Scripts/Kanto/Leveling/Route10 - RockTunnel.lua now
uses the confirmed Rock Tunnel 1/2 warp endpoints in the 2026-10-17
LinkGraph v2 upload. It walks a complete north-to-south and south-to-north
route and always heads back toward the northern Pokecenter when healing.

**Important:** Rock Tunnel 1 and Rock Tunnel 2 contain multiple disconnected
sectors despite sharing map names. The script classifies its sector using
the confirmed arrival coordinates at each map change, remembers that sector
while staying on the same map, and falls back to coarse geometric partitions
only if started mid-cave without an observed arrival. The link graph alone
does not contain full walkable/collision geometry for arbitrary start cells.

To check the route and the existing BetterQuesting NPC regressions:

    dotnet run --project Tests/MoonSharpRegression

## Changes

- Removed the `Relog on stop` option and its `onStop()` relog behavior.
- Renumbered the remaining BetterQuesting options from 1 through 4.
- Updated all BetterQuesting quest references to the new option indices.

- Audited `talkToNpcOnCell(...)` coordinates against the supplied `maps.zip` using PROCatchem's map parser.
- Corrected confirmed NPC/object positions on `Viridian Maze`, `Bills House`, `Pokemon Tower 6F`, and `Indigo Plateau`.
- Kept coordinates unchanged where the corresponding map file was not present in `maps.zip`; those maps are listed in the separately generated audit report.

### Updated map audit (`maps(1).zip`)

- Re-audited BetterQuesting NPC interaction coordinates against the updated map archive using PROCatchem's binary map parser and `Map.FindNpcOnCell()` behavior.
- Updated the Indigo Plateau Hoenn Traveler check from `(21, 10)` to `(21, 7)`.
- Kept Magma Hideout 4F on Magma Admin Tabitha at `(16, 31)` and removed the stale `(15, 31)` branch.
- Updated Mossdeep Gym to reach the current top-right leader room and talk to Liza at `(51, 8)` and Tate at `(52, 8)`.
- Replaced `talkToNpcOnCell(7, 17)` in Sky Pillar Entrance Cave 1F with `moveToCell(7, 17)` because the map object is a `TileScript`, which PROCatchem intentionally excludes from NPC interaction.
- Replaced the empty Sootopolis City Gym B1F talk target `(13, 6)` with movement to the current upper link `(13, 21)`.
- Replaced the unreachable Rocket Hideout B2F empty-cell talk fallback `(2, 3)` with movement to the valid B3F link `(23, 4)`.
- Coordinates whose map handlers are still absent from the updated archive remain unchanged and are listed in the separately generated audit report.
