-- Run from ProScript root: lua Tests/test_discoverable_visit.lua
-- Or use MoonSharp: dotnet run --project Tests/MoonSharpRegression
package.loaded["Libs/syslib"] = {
    debug = function() end,
    error = function(msg) error(msg) end,
    tableHasValue = function(values,target)
        for _,v in ipairs(values) do if v==target then return true end end
        return false
    end
}
package.loaded["Libs/gamelib"] = {hasPokemonWithMove=function() return false end}
package.loaded["Libs/teamlib"] = {}
package.loaded["blacklist"] = {}
local map = "Route 25"
local active = {{id=7122,x=75,y=5}}
local calls = 0
getMapName = function() return map end
hasItem = function() return false end
getActiveDigSpots = function() return {} end
getActiveHeadbuttTrees = function() return {} end
getActiveBerryTrees = function() return active end
getDiscoverableItems = function() return {} end
getDiscoverablePokestops = function() return {} end
getDiscoverableAbandonedPokemon = function() return {} end
isNpcOnCell = function(x,y)
    for _,v in ipairs(active) do
        if v.x==x and v.y==y then return true end
    end
    return false
end
talkToNpcOnCell = function() calls=calls+1;return true end
local Quest = dofile("Quests/Quest.lua")
local quest = Quest:new("NPC capture replay","Route 25",1,{})
assert(quest:checkDiscoverables()==true,"first Berry request")
assert(calls==1,"first NPC request")
assert(not quest:checkDiscoverables(),"same Berry should not retry endlessly")
assert(calls==1,"duplicate NPC request")
active={{id=7123,x=74,y=5}}
assert(quest:checkDiscoverables()==true,"next Berry still reachable")
assert(calls==2,"different NPC request")
active={}
assert(not quest:checkDiscoverables(),"authoritative @ removed both NPCs")
assert(calls==2,"ghost NPC retried")
active={{id=7122,x=75,y=5}}
map="Route 24"
assert(quest:checkDiscoverables()==true,"new map visit resets attempts")
assert(calls==3,"map reset request")
-- An authoritative snapshot can temporarily remove every optional NPC.
-- Returning to the same map should not resurrect already-attempted NPCs.
map="Route 25"
active={}
assert(not quest:checkDiscoverables(),"empty @ snapshot must not start a talk")
active={{id=7122,x=75,y=5}}
assert(quest:checkDiscoverables()==true,"revisited map after Route 24 can try Berry again")
assert(calls==4,"map-reentry sends a single new interaction")
assert(not quest:checkDiscoverables(),"repeated @ on this visit cannot re-arm the old Berry")
assert(calls==4,"repeated @ must not trigger another talk")

-- Distinct NPC IDs at the same coordinates must NOT share the attempt key.
map="Route 21"
active={{id=8200,x=3,y=4}}
assert(quest:checkDiscoverables()==true,"first ID at shared cell")
active={{id=8201,x=3,y=4}}
assert(quest:checkDiscoverables()==true,"replacement ID at same cell")
assert(calls==6,"different NPC IDs each receive one request")
active={}
assert(not quest:checkDiscoverables(),"removed replacement must not be retried")
assert(calls==6,"removed NPC cannot generate ghost talk")

-- A rejected movement/talk request must remain eligible; only a successfully
-- queued interaction consumes the per-visit attempt. No generalized cooldown.
map="Route 23"
active={{id=8300,x=13,y=7}}
local failFirst=true
talkToNpcOnCell=function()
    calls=calls+1
    if failFirst then failFirst=false; return false end
    return true
end
assert(not quest:checkDiscoverables(),"a rejected NPC request returns false")
assert(quest:checkDiscoverables()==true,"failed NPC request is retryable")
assert(not quest:checkDiscoverables(),"successful retry is attempted just once")
assert(calls==8,"one rejected attempt and one successful retry")

-- Older callers without npcId still fall back to map/kind/cell identity.
map="Route 22"
active={{x=9,y=2}}
assert(quest:checkDiscoverables()==true,"legacy x/y-only entry accepted")
assert(not quest:checkDiscoverables(),"legacy cell is deduplicated")
assert(calls==9,"legacy entry is not spammed")

-- Pokestops are deliberately outside the nonrepeatable-attempt ledger;
-- their existing dialog-triggered cooldown is unaffected by this change.
local oldIsNpcOnCell=isNpcOnCell
isNpcOnCell=function(x,y)
    return (map=="Pewter City" and x==11 and y==6) or oldIsNpcOnCell(x,y)
end
getDiscoverablePokestops=function() return {{id=8400,x=11,y=6}} end
map="Pewter City"
active={}
assert(quest:checkDiscoverables()==true,"Pokestop remains usable independently")
assert(calls==10,"Pokestop interaction initiated")
quest:dialog("The Pokestop is not available yet.")
assert(not quest:checkDiscoverables(),"Pokestop dialog installs its existing cooldown")
assert(calls==10,"Pokestop cooldown blocks an immediate retry")
map="Cerulean City"
assert(not quest:checkDiscoverables(),"other map is not an active Pokestop")
map="Pewter City"
assert(not quest:checkDiscoverables(),"Pokestop cooldown persists across map visits")
assert(calls==10,"map reentry does not bypass Pokestop-specific cooldown")

print("PASS BetterQuesting discoverable lifecycle, per-NPC retry and Pokestop regression")
