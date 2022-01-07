
name = "Tracking: Viridian Forest"
author = "Silv3r"
description = [[This script will track the desire pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere in Viridian Forest.]]

function onPathAction()
	elseif getMapName() == "Viridian Forest" then
		moveToRectangle(20, 17, 21, 23)
	end
end

function onBattleAction()
	if isWildBattle() and (isOpponentShiny() or getOpponentName() == "Ditto") then
		fatal("Your desire pokemon has been found!")
	else
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
	end
end
