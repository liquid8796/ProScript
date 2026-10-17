-- Mocked Rock Tunnel movement regression using PROCatchem's MoonSharp engine.
local map, px, py, mx, my, usable, healing, sectorLogs
team = {
 onStart=function(lvl) assert(lvl==99); return true end,
 setMountForTrainingMap=function() return false end,
 isTrainingOver=function() return false end,
 isSearching=function() return false end,
 useLeftovers=function() return false end,
 getLowestIndexOfUsablePokemon=function() return 1 end,
 antibanclassroom=function() return true end,
 onBattleFighting=function() return "battle" end,
 onBattleMessage=function(m) return "battle:"..m end,
 onAntibanDialogMessage=function(m) return "dialog:"..m end,
 onSystemMessage=function(m) return "system:"..m end,
}
require=function(mod) assert(mod=="../../Libs/teamlib"); return team end
getMapName=function() return map end
getPlayerX=function() return px end
getPlayerY=function() return py end
getOption=function() return false end
isTeamSortedByLevelAscending=function() return true end
getUsablePokemonCount=function() return usable end
getPokemonLevel=function() return 35 end
moveToCell=function(x,y) mx,my=x,y; return true end
usePokecenter=function() healing=healing+1; return true end
log=function(m) sectorLogs[#sectorLogs+1]=m end
fatal=function(m) error(m) end

dofile("Scripts/Kanto/Leveling/Route10 - RockTunnel.lua")
local checked=0
local function start()
  map,px,py,mx,my=nil,0,0,nil,nil
  usable,healing,sectorLogs=3,0,{}
  assert(onStart()==true)
end
local function step(where,x,y,tx,ty,context)
  map,px,py,mx,my=where,x,y,nil,nil
  assert(onPathAction()==true,"not moved: "..context)
  assert(mx==tx and my==ty,context..": expected "..tx..","..ty..
      ", got "..tostring(mx)..","..tostring(my))
  checked=checked+1
end
start()
-- Full traverse and reverse through ALL four floor-to-floor warp pairs.
step("Pokecenter Route 10",9,21,9,22,"Pokecenter exit")
step("Route 10",18,5,11,5,"north Route 10 entry")
step("Rock Tunnel 1",43,10,35,16,"east sector -> upper")
step("Rock Tunnel 2",36,16,7,5,"upper sector -> west")
step("Rock Tunnel 1",7,7,8,15,"west sector -> lower")
step("Rock Tunnel 2",10,13,8,26,"lower sector -> south")
step("Rock Tunnel 1",7,30,21,32,"south sector -> southern Route10")
step("Route 10",5,45,5,44,"turn around at southern Route10")
step("Rock Tunnel 1",21,31,7,30,"south sector -> lower")
step("Rock Tunnel 2",8,26,10,13,"lower sector -> west")
step("Rock Tunnel 1",8,15,7,7,"west sector -> upper")
step("Rock Tunnel 2",7,5,36,16,"upper sector -> east")
step("Rock Tunnel 1",35,16,43,11,"east sector -> northern Route10")
step("Route 10",11,6,11,5,"repeat southward tour")
assert(#sectorLogs==10,"log only on cave map transitions")
checked=checked+1

start()
step("Route 10",18,5,11,5,"north beginning")
step("Rock Tunnel 1",43,10,35,16,"east landing")
step("Rock Tunnel 2",36,16,7,5,"upper landing")
local count=#sectorLogs
step("Rock Tunnel 2",14,14,7,5,"sector must not change mid-map")
assert(#sectorLogs==count,"no repeated logs")
checked=checked+1

local recovery={
 {"Rock Tunnel 1",43,10,43,11},
 {"Rock Tunnel 1",7,7,7,7},
 {"Rock Tunnel 1",21,31,7,30},
 {"Rock Tunnel 2",36,16,36,16},
 {"Rock Tunnel 2",10,13,10,13},
}
for _, row in ipairs(recovery) do
  start(); usable=1
  step(row[1],row[2],row[3],row[4],row[5],"heal from "..row[1].." ("..row[2]..","..row[3]..")")
end
start(); usable=1
step("Route 10",5,45,5,44,"heal south Route10")
step("Rock Tunnel 1",21,31,7,30,"heal south sector")
step("Rock Tunnel 2",8,26,10,13,"heal lower sector")
step("Rock Tunnel 1",8,15,7,7,"heal west sector")
step("Rock Tunnel 2",7,5,36,16,"heal upper sector")
step("Rock Tunnel 1",35,16,43,11,"heal east sector")
step("Route 10",11,6,18,4,"heal on northern Route10")
map="Pokecenter Route 10"
assert(onPathAction()==true and healing==1,"Pokecenter heals")
checked=checked+1

-- Starting/restarting in the middle of a cave sector with no recent spawn.
local starts={
 {"Rock Tunnel 1",38,13,35,16},
 {"Rock Tunnel 1",14,10,8,15},
 {"Rock Tunnel 1",16,25,21,32},
 {"Rock Tunnel 2",25,9,7,5},
 {"Rock Tunnel 2",15,18,8,26},
}
for _, row in ipairs(starts) do
  start()
  step(row[1],row[2],row[3],row[4],row[5],"resume mid-sector")
end
start()
step("Route 10",5,45,5,44,"start on southern Route10")
step("Rock Tunnel 1",21,31,7,30,"go north after southern Route10")
assert(onBattleAction()=="battle")
assert(onBattleMessage("ok")=="battle:ok")
assert(onDialogMessage("hi")=="dialog:hi")
assert(onSystemMessage("done")=="system:done")
checked=checked+4
print("PASS Rock Tunnel LinkGraph v2 route ("..checked.." checks)")
