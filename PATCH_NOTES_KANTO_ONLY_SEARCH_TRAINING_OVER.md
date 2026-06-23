# Kanto Only Search training-over fix

Patched Kanto standalone scripts so `Only search` no longer stops with `Complete training! Stop the bot.` just because the team reached or exceeded the training level target.

## Changes

- `Scripts/Kanto/Leveling/teamlib.lua`
  - `team.isTrainingOver(maxLv)` now returns `false` when `team.isSearching()` / option 3 `Only search` is enabled.
  - Normal training-over behavior is unchanged when `Only search` is disabled: it returns `true` only when every team Pokémon is at least `maxLv`.

- Kanto route/capture/EV scripts
  - Any remaining `team.isTrainingOver(maxLv)` stop guard was protected with `and not team.isSearching()`.
  - Any remaining route-to-grass condition that previously required the lowest usable Pokémon to be below `maxLv` now also allows `team.isSearching()`, so the script keeps moving to hunt/search areas while Only search is enabled.

## Result

When `Only search` is enabled:

- The script does not stop with `Complete training! Stop the bot.`.
- The route continues going to grass/search areas even when the team is already above `maxLv`.
- Battle capture behavior remains controlled by `teamlib` hunt logic.
