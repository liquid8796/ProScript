
name = "Tracking: Viridian Forest"
author = "Silv3r"
description = [[This script will track the desire pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere in Route 21.]]

function onPathAction()
	if getMapName() == "Route 21" then
		moveToRectangle(15, 3, 19, 8)
	end
end

function onBattleAction()
	if isWildBattle() and (isOpponentShiny() or getOpponentName() == "Mr. Mime") then
		fatal("Your desire pokemon has been found!")
	else
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
	end
end
