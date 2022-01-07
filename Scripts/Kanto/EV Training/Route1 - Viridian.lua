
name = "Leveling: Route 10 (near the Pokecenter)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Route 1 or Viridian city.]]

mode_catch = 1
setOptionName(1, "Auto relog")

function onPathAction()
	setMount("Xmas Dragonite Mount")
	if isPokemonUsable(2) and getPokemonHealthPercent(2) > 30 then
		if getMapName() == "Pokecenter Viridian" then
			moveToCell(9,22)
		elseif getMapName() == "Viridian City" then
			moveToCell(48,61)
		elseif getMapName() == "Route 1 Stop House" then
			moveToCell(3,12)	
		elseif getMapName() == "Route 1" then
			moveToRectangle(18, 12, 25,13)
		elseif getMapName() == "Prof. Antibans Classroom" then
			onAntibanPathAction()
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
	if mode_catch == 1 then
		if isWildBattle() and (isOpponentShiny() or getOpponentName() == "Shinx") then
			log("Your desire pokemon has been found!")
			return useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball")
		else
			if getActivePokemonNumber() == 1 and getPokemonHealthPercent(1) > 30 then
				sendAnyPokemon()
				--return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
			else
				--return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
				--return relog(1,"Reconnecting for healing")
				if getPokemonHealthPercent(2) > 30 then
					return attack() or sendUsablePokemon() or sendAnyPokemon()
				else
					return relog(1,"Reconnecting for healing")
				end
			end
		end

	else
		if isWildBattle() and isOpponentShiny() then
			if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
				return
			end
		end
		if getActivePokemonNumber() == 1 and getPokemonHealthPercent(1) > 30 then
			return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
		else
			--return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
			return relog(1,"Reconnecting for healing")
		end
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

registerHook("onPathAction", onAntibanPathAction)
registerHook("onDialogMessage", onAntibanDialogMessage)