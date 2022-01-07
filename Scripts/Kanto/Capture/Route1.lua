name = "Tracking: Route1"
author = "Liquid"
description = [[This script will track the desire pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere in Route 1.]]

setOptionName(1, "Auto relog")
function onPathAction()
	setMount("Xmas Dragonite Mount")
	if isPokemonUsable(1) then
		if getMapName() == "Pokecenter Viridian" then
			moveToCell(9,22)
		elseif getMapName() == "Viridian City" then
			moveToCell(48,61)
		elseif getMapName() == "Route 1 Stop House" then
			moveToCell(3,12)	
		elseif getMapName() == "Route 1" then
			moveToGrass()
		elseif getMapName() == "Prof. Antibans Classroom" then
			onAntibanPathAction()
		elseif getItemQuantity("Pokeball") < 10 then
			fatal("Enough target, stop the bot!")
		end
	else
		if getMapName() == "Route 1" then
			moveToCell(14,4)
		elseif getMapName() == "Route 1 Stop House" then
			moveToCell(4,2)
		elseif getMapName() == "Viridian City" then
			moveToCell(44,43)
		elseif getMapName() == "Pokecenter Viridian" then
			usePokecenter()
		elseif getMapName() == "Prof. Antibans Classroom" then
			onAntibanPathAction()
		end
	end
end

function onBattleAction()
	if isWildBattle() and (isOpponentShiny() or getOpponentName() == "Hoothoot" or getOpponentName() == "Shinx") then
		return useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball")
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

registerHook("onPathAction", onAntibanPathAction)
registerHook("onDialogMessage", onAntibanDialogMessage)