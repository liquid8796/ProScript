# BetterQuesting Lua regression runner

Run from the ProScript repository root:

    dotnet run --project Tests/MoonSharpRegression

Runs Tests/test_discoverable_visit.lua using MoonSharp 2.0.0.0,
the same Lua engine as PROCatchem. This uses mock server-side NPC
snapshots and does not connect to a game server.

Only nonrepeatable optional Dig/Headbutt/Berry/item/abandoned NPCs are
deduplicated per map visit. Pokestops retain their separate dialog-triggered
cooldown; this does not introduce any global NPC cooldown.

Rock Tunnel test: test_rock_tunnel_route.lua verifies all eight cross-floor warps,
north/south Route 10 loops, recovery, sector memory and restart fallback.
Map-area fallback is inferred from the old script; LinkGraph alone contains
warp endpoints rather than full walkable collision geometry.
