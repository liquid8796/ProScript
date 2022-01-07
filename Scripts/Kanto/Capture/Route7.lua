
name = "Tracking: Viridian Forest"
author = "Liquid"
description = [[This script will track the desire pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere in Route 7.]]

function onPathAction()
	if getMapName() == "Route 7" then
		moveToRectangle(13, 9, 21, 21)
	end
end

function onBattleAction()
	if isWildBattle() and (isOpponentShiny() or getOpponentName() == "Houndour") then
		fatal("Your desire pokemon has been found!")
	else
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
	end
end
