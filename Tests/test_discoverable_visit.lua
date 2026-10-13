-- Run from ProScript repo root: lua Tests/test_discoverable_visit.lua
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
print("PASS BetterQuesting discoverable visit regression (10 assertions)")
