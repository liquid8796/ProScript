# Kanto teamlib Only Search level-safe weaken update

Updated `Scripts/Kanto/Leveling/teamlib.lua` Only Search capture behavior.

## New behavior

When `Only search` is enabled and the encountered wild Pokemon is a hunt target:

1. If the active Pokemon is higher level than the opponent by 1-4 levels and the opponent HP is still >= 50%, the script attacks/uses a move to weaken it.
2. If the active Pokemon is more than 4 levels higher than the opponent, or otherwise not suitable for safe weakening, the script searches the team for another usable Pokemon that is higher level than the opponent by 1-4 levels.
3. If a suitable team Pokemon is found, the script switches to it first. On the next battle turn it continues the weaken-then-catch flow.
4. If no suitable team Pokemon exists, the script throws a ball immediately.
5. If opponent HP is already below 50%, the script throws a ball immediately.

Ball priority remains:

```lua
Ultra Ball -> Great Ball -> Pokeball
```

Non-target Pokemon in Only Search mode are still skipped by preferring `run()`.
