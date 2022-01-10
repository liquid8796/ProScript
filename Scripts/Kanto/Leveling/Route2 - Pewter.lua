
name = "Leveling: Route 2 (near Pewter)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Pewter City and Route 2.]]

local listPokemon = require "listPokemon"
local maxLv = 18

function onStart()
	setOptionName(1, "Auto relog")
	setMount("Latios Mount")
	log("Training pokemon until reach level "..maxLv)
	--for longer botting runs
	return disablePrivateMessage()
end

function onPathAction()
	while not isTeamSortedByLevelAscending() do
		return sortTeamByLevelAscending()
	end
	if isTrainingOver() then
		fatal("Complete training! Stop the bot.")
	end
	if getUsablePokemonCount() > 1 and getPokemonLevel(getLowestIndexOfUsablePokemon()) < maxLv then
		if getMapName() == "Pokecenter Pewter" then
			moveToCell(9,22)
		elseif getMapName() == "Pewter City" then
			moveToCell(16,55)
		elseif getMapName() == "Route 2" then
			moveToGrass()
		elseif getMapName() == "Prof. Antibans Classroom" then
			log("Quiz detected, talking to the prof.")
			talkToNpc("Prof. Antiban")
		end
	else
		if getMapName() == "Route 2" then
			moveToCell(25,0)
		elseif getMapName() == "Pewter City" then
			moveToCell(24,35)
		elseif getMapName() == "Pokecenter Pewter" then
			usePokecenter()
		elseif getMapName() == "Prof. Antibans Classroom" then
			log("Quiz detected, talking to the prof.")
			talkToNpc("Prof. Antiban")
		end
	end
end

function onBattleAction()
	local isTeamUsable = getTeamSize() == 1 --if it's our starter, it has to atk
		or getUsablePokemonCount() > 1		--otherwise we atk, as long as we have 2 usable pkm
	if isTeamUsable then
		local opponentLevel = getOpponentLevel()
		local myPokemonLvl  = getPokemonLevel(getActivePokemonNumber())
		if opponentLevel >= myPokemonLvl then
			local requestedId, requestedLevel = getMaxLevelUsablePokemon()
			if requestedLevel > myPokemonLvl and requestedId ~= nil	then 
				return sendPokemon(requestedId) 
			end
		end
		if isWildBattle() and (isOpponentShiny() or (isInListPokemon(listPokemon, getOpponentName()))) then		
			if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
				return
			else
				return attack() or sendUsablePokemon() or sendAnyPokemon() or run() 
			end
		else
			return attack() or sendUsablePokemon() or sendAnyPokemon() or run()
		end
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

function getLowestIndexOfUsablePokemon()
	for i=1,6 do
		if isPokemonUsable(i) then
			return i
		end
	end
	return 6
end
function isTrainingOver()
	local count = 0
	for i=1,6 do
		if getPokemonLevel(i) >= maxLv then
			count = count + 1
		end
	end
	if count < 6 then return false end
	return true
end
function addListToFile(list, path)
	local line = "local listPokemon = \n{"
	for key, value in pairs(list) do		
        line = line .. "\n['"..key.."']="..value..","
    end
	line = line .. "\n}\nreturn listPokemon"
	writeToFile(path, line, true)
end
function setTeamFightBattle()
	local opponentLevel = getOpponentLevel()
	local myPokemonLvl  = getPokemonLevel(getActivePokemonNumber())
	if opponentLevel >= myPokemonLvl then
		local requestedId, requestedLevel = getMaxLevelUsablePokemon()
		if requestedLevel > myPokemonLvl and requestedId ~= nil	then 
			return sendPokemon(requestedId) 
		end
	end
end
function getMaxLevelUsablePokemon()
	local currentId
	local currentLevel
	for pokemonId=1, getTeamSize(), 1 do
		local pokemonLevel = getPokemonLevel(pokemonId)
		if  (currentLevel == nil or pokemonLevel > currentLevel)
			and isPokemonUsable(pokemonId) then
			currentLevel = pokemonLevel
			currentId    = pokemonId
		end
	end
	return currentId, currentLevel
end
function isInListPokemon(list, val)
    for key, value in pairs(list) do		
        if key == val and value < 2 then	
            return true
        end
    end
    return false
end
function split(str, sep)
   local result = {}
   local regex = ("([^%s]+)"):format(sep)
   for each in str:gmatch(regex) do
      table.insert(result, each)
   end
   return result
end

antibanQuestions = {

["What type is Flygon?"] = "Dragon/Ground",
["How many Pokemon can Eevee currently evolve into?"] = "8",
["Which of these are effective against Dragon?"] = "Dragon",
["What level does Litleo evolve into Pyroar?"] = "35",
["Articuno is one of the legendary birds of Kanto."] = "True",

}

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
function onBattleMessage(message)
	if stringContains(message, "caught") then
		listPokemon[getOpponentName()] = listPokemon[getOpponentName()] + 1
		--addListToFile(listPokemon, "D:\\ProScript\\Scripts\\Kanto\\Leveling\\listPokemon.lua")
		addListToFile(listPokemon, "C:\\PRO_Script\\Scripts\\Kanto\\Leveling\\listPokemon.lua")
	end
end

registerHook("onDialogMessage", onAntibanDialogMessage)
