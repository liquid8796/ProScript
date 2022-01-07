
name = "Leveling: Route 1 - PalletTown"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Route 1 or PalletTown.]]

mode_catch = 1
setOptionName(1, "Auto relog")

function onPathAction()
	setMount("Xmas Dragonite Mount")
	if isPokemonUsable(1) and getPokemonHealthPercent(1) > 49 then
		if getMapName() == "Player House Pallet" then
			moveToCell(4,10)
		elseif getMapName() == "Pallet Town" then
			moveToCell(13,0)
		elseif getMapName() == "Route 1" then
			moveToRectangle(14, 48, 16, 49)
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
	if mode_catch == 1 then
		if isWildBattle() and (isOpponentShiny() or getOpponentName() == "Shinx") then
			log("Your desire pokemon has been found!")
			return useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball")
		else
			if getActivePokemonNumber() == 1 and getPokemonHealthPercent(1) > 30 then
				return attack() or sendUsablePokemon() or run() or sendAnyPokemon()
			else
				--return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
				return relog(1,"Reconnecting for healing")
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