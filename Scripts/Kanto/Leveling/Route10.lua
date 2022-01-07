
name = "Leveling: Route 10 (near the Pokecenter)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere on Route 10.]]

mode_catch = 0
notfound = 0

setOptionName(1, "Auto relog")

function onPathAction()
	if isPokemonUsable(1) then
		if getMapName() == "Pokecenter Route 10" then
			moveToCell(9,22)
		elseif getMapName() == "Route 10" then
			moveToRectangle(13, 10, 20,11)
		end
	else
		if getMapName() == "Route 10" then
			moveToCell(18,4)
		elseif getMapName() == "Pokecenter Route 10" then
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

function onStop()

	if getOption(1) then
		return relog(5,"Restart bot after 5s")
	else
		return
	end
end