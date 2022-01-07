
name = "Tracking: Viridian Forest"
author = "Liquid"
description = [[This script will track the desire pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere in Viridian Forest.]]

local listPokemon = 
{
'Pikachu','Oddish','Caterpie','Butterfree','Budew','Beedrill','Weedle','Rattata',
}

function onStart()
	setOptionName(1, "Auto relog")
	setMount("Xmas Dragonite Mount")
	
	--for longer botting runs
	if DISABLE_PM and isPrivateMessageEnabled() then
		log("Private messages disabled.")
		return disablePrivateMessage()
	end
end

function onPathAction()
	if isPokemonUsable(1) then
		if getMapName() == "Pokecenter Pewter" then
			moveToCell(9,22)
		elseif getMapName() == "Pewter City" then
			moveToCell(16,55)
		elseif getMapName() == "Route 2" then
			moveToCell(10,42)	
		elseif getMapName() == "Route 2 Stop2" then
			moveToCell(4,12)
		elseif getMapName() == "Viridian Forest" then
			moveToGrass()
			--moveToRectangle(20, 17, 21, 23) --Coordinator for pikachu
		elseif getMapName() == "Prof. Antibans Classroom" then
			onAntibanPathAction()
		end
	else
		if getMapName() == "Viridian Forest" then
			moveToCell(12,15)
		elseif getMapName() == "Route 2 Stop2" then
			moveToCell(4,2)
		elseif getMapName() == "Route 2" then
			moveToCell(25,0)
		elseif getMapName() == "Pewter City" then
			moveToCell(24,35)
		elseif getMapName() == "Pokecenter Pewter" then
			usePokecenter()
		elseif getMapName() == "Prof. Antibans Classroom" then
			onAntibanPathAction()
		end
	end
end

function onBattleAction()
	if isWildBattle() and (isOpponentShiny() or (isInListPokemon(listPokemon, getOpponentName()) and not isAlreadyCaught())) then
		return fatal("Your desire pokemon has been found!")
	else
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
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
    for key, value in ipairs(list) do
        if value == val then
            return true
        end
    end
    return false
end

registerHook("onPathAction", onAntibanPathAction)
registerHook("onDialogMessage", onAntibanDialogMessage)