# Kanto teamlib capture mode fixes

## Only search capture behavior

- When `Only search` is enabled and the wild Pokémon is a hunt target, the script now weakens it first.
- It attacks while opponent HP is `>= 50%`.
- Once opponent HP is below `50%`, it throws balls in this order: `Ultra Ball`, `Great Ball`, `Pokeball`.
- When the wild Pokémon is not a hunt target, it still prioritizes `run()`.

## Kanto standalone listPokemon path

- Replaced the old absolute save path with the relative Kanto standalone path:
  `Scripts/Kanto/Leveling/listPokemon.lua`

## Route 1 hunt list

Updated `Scripts/Kanto/Leveling/listPokemon.lua` from the PRO Wiki Route 1 wild Pokémon table.
