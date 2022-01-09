
name = "Leveling: Route 22 (near the Viridian city)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Route 1 or Viridian city.]]

local listPokemon = require "listPokemon"

function onStart()
	setOptionName(1, "Auto relog")
	setMount("Latios Mount")
	sortTeamByLvAscending()
	--for longer botting runs
	return disablePrivateMessage()
end

function onPathAction()
	while not isTeamSortedByLevelAscending() do
		return sortTeamByLevelAscending()
	end
	if isPokemonUsable(1) then
		if getMapName() == "Pokecenter Viridian" then
			moveToCell(9,22)
		elseif getMapName() == "Viridian City" then
			moveToCell(0,48)
		elseif getMapName() == "Route 22" then
			moveToGrass()
		elseif getMapName() == "Prof. Antibans Classroom" then
			onAntibanPathAction()
		end
	else
		if getMapName() == "Route 22" then
			moveToCell(60,11)
		elseif getMapName() == "Viridian City" then
			moveToCell(44,43)
		elseif getMapName() == "Pokecenter Viridian" then
			--usePokecenter()
			talkToNpcOnCell(9,15)
		elseif getMapName() == "Prof. Antibans Classroom" then
			onAntibanPathAction()
		end
	end
end

function onBattleAction()
	if isWildBattle() and (isOpponentShiny() or (isInListPokemon(listPokemon, getOpponentName()) and getOpponentLevel() > 5)) then		
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return
		end
	end
	if getActivePokemonNumber() == 1 then
		return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
	else
		--relog(1,"Restart for healing!")
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
	end
end

function onStop()
	if getOption(1) then
		return relog(2,"Restart bot after 2s")
	else
		return
	end
end

antibanQuestions = {

["What type is Flygon?"] = "Dragon/Ground",
["How many Pokemon can Eevee currently evolve into?"] = "8",
["Which of these are effective against Dragon?"] = "Dragon",
["What level does Litleo evolve into Pyroar?"] = "35",
["Articuno is one of the legendary birds of Kanto."] = "True",

}

function onAntibanPathAction()
	if getMapName() == "Prof. Antibans Classroom" then
		log("Quiz detected, talking to the prof.")
		talkToNpc("Prof. Antiban")
	end
end

function onAntibanDialogMessage(message)
	if getMapName() ~= "Prof. Antibans Classroom" then
		return
	end
	if stringContains(message, "incorrect") then
		fatal("Could not answer correctly, stopping the bot.")
	end
	for key, value in pairs(antibanQuestions) do
		if stringContains(message, key) then
			pushDialogAnswer(value)
		end
	end
end

function isInListPokemon(list, val)
    for key, value in pairs(list) do		
        if key == val and value < 2 then	
            return true
        end
    end
    return false
end

function addListToFile(list, path)
	local line = "local listPokemon = \n{"
	for key, value in pairs(list) do		
        line = line .. "\n['"..key.."']="..value..","
    end
	line = line .. "\n}\nreturn listPokemon"
	writeToFile(path, line, true)
end

function sortTeamByLvAscending()
	while not isTeamSortedByLevelAscending() do
		return sortTeamRangeByLevelAscending(1, getTeamSize())
	end
end

function split(str, sep)
   local result = {}
   local regex = ("([^%s]+)"):format(sep)
   for each in str:gmatch(regex) do
      table.insert(result, each)
   end
   return result
end

function onBattleMessage(message)
	if stringContains(message, "caught") then
		listPokemon[getOpponentName()] = listPokemon[getOpponentName()] + 1
		addListToFile(listPokemon, "D:\\ProScript\\Scripts\\Kanto\\Leveling\\listPokemon.lua")
		--addListToFile(listPokemon, "C:\\PRO_Script\\BetterQuesting.lua\\Scripts\\Kanto\\Leveling\\listPokemon.lua")
	end
end

registerHook("onPathAction", onAntibanPathAction)
registerHook("onDialogMessage", onAntibanDialogMessage)