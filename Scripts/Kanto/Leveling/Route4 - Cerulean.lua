
name = "Leveling: Route 4 (near Cerulean)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Cerulean City or Route 4.]]

mode_catch = 1
notfound = 0

function onPathAction()
	if isPokemonUsable(1) then
		if getMapName() == "Pokecenter Cerulean" then
			moveToCell(9,22)
		elseif getMapName() == "Cerulean City" then
			moveToCell(0,21)
		elseif getMapName() == "Route 4" then
			moveToRectangle(74, 20, 79, 28)
		end
	else
		if getMapName() == "Route 4" then
			moveToCell(96,22)
		elseif getMapName() == "Cerulean City" then
			moveToCell(26,30)
		elseif getMapName() == "Pokecenter Cerulean" then
			usePokecenter()
		end
	end
end

function onBattleAction()
	if mode_catch == 1 then
		if isWildBattle() and (isOpponentShiny() or getOpponentName() == "Pineco") then
			fatal("Your desire pokemon has been found!")
		else
			if getActivePokemonNumber() == 1 then
				return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
			else
				return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
			end
		end

	else
		if isWildBattle() and isOpponentShiny() then
			if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
				return
			end
		end
		if getActivePokemonNumber() == 1 then
			return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
		else
			return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
		end
	end
end

