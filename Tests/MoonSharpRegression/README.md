# BetterQuesting Lua regression runner

Run from the ProScript repository root:

    dotnet run --project Tests/MoonSharpRegression

Runs Tests/test_discoverable_visit.lua using MoonSharp 2.0.0.0,
the same Lua engine as PROCatchem. This uses mock server-side NPC
snapshots and does not connect to a game server.

Only nonrepeatable optional Dig/Headbutt/Berry/item/abandoned NPCs are
deduplicated per map visit. Pokestops retain their separate dialog-triggered
cooldown; this does not introduce any global NPC cooldown.
