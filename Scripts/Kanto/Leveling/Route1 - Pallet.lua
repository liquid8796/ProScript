
name = "Leveling: Route 1 - PalletTown"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Route 1 or PalletTown.]]

local listPokemon = require "listPokemon"

function addListToFile(list, path)
	local line = "local listPokemon = \n{\n"
	for key, value in pairs(list) do		
        line = line .. "['"..key.."']="..value..","
    end
	line = line .. "\n}\nreturn listPokemon"
	writeToFile(path, line, true)
end
function onStart()
	setOptionName(1, "Auto relog")
	setMount("Latios Mount")
	--for longer botting runs
	return disablePrivateMessage()
end

function onPathAction()
	if isPokemonUsable(1) and getPokemonHealthPercent(1) > 50 then
		if getMapName() == "Player Bedroom Pallet" then
			moveToCell(12,4)
		elseif getMapName() == "Player House Pallet" then
			moveToCell(4,10)
		elseif getMapName() == "Pallet Town" then
			moveToCell(13,0)
		elseif getMapName() == "Route 1" then
			--moveToRectangle(13, 48, 16, 49)
			moveToGrass()
		end
	else
		if getMapName() == "Route 1" then
			moveToCell(15,50)
		elseif getMapName() == "Pallet Town" then
			moveToCell(6,12)
		elseif getMapName() == "Player House Pallet" then
			talkToNpcOnCell(7,6)
		end
	end
end

function onBattleAction()
	if isWildBattle() and (isOpponentShiny() or (isInListPokemon(listPokemon, getOpponentName()))) then		
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			listPokemon[getOpponentName()] = listPokemon[getOpponentName()] + 1
			return
		end
	end
	if getActivePokemonNumber() == 1 and getPokemonHealthPercent(1) > 50 then
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
        if key == val and value < 3 then	
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

function onBattleMessage(message)
	if stringContains(message, "caught") then
		addListToFile(listPokemon, "D:\\ProScript\\Scripts\\Kanto\\Leveling\\listPokemon.lua")
	end
	return false
end

registerHook("onPathAction", onAntibanPathAction)
registerHook("onDialogMessage", onAntibanDialogMessage)