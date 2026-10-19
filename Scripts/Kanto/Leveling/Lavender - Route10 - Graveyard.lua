
name = "Leveling: Mt. Moon Entrance (near Route 3)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere in Lavender Town / Route 10 / Graveyard.]]

local team = require "../../Libs/teamlib"
local maxLv = 30

function onStart()
	return team.onStart(maxLv)
end

function onPathAction()
	if team.setMountForTrainingMap() then
		return
	end
	while not isTeamSortedByLevelAscending() and getOption(4) do
		return sortTeamByLevelAscending()
	end
	if team.isTrainingOver(maxLv) and not team.isSearching() then
		return fatal("Complete training! Stop the bot.")
	end
	if team.useLeftovers() then
		return
    end
	if getUsablePokemonCount() > 1 
		and (getPokemonLevel(team.getLowestIndexOfUsablePokemon()) < maxLv
		or team.isSearching())
	then
		if getMapName() == "Pokecenter Lavender" then
			moveToCell(9,22)
		elseif getMapName() == "Lavender Town" then
			moveToCell(15,0)
		elseif getMapName() == "Route 10" then
			moveToCell(0,61)
		elseif getMapName() == "Lavender Town Graveyard" then
			moveToGrass()
		elseif getMapName() == "Prof. Antibans Classroom" then
			return team.antibanclassroom()
		end
	else
		if getMapName() == "Lavender Town Graveyard" then
			moveToCell(60,36)
		elseif getMapName() == "Route 10" then
			moveToCell(15,71)
		elseif getMapName() == "Lavender Town" then
			moveToCell(9,5)
		elseif getMapName() == "Prof. Antibans Classroom" then
			return team.antibanclassroom()
		end
	end
end

function onBattleAction()
	return team.onBattleFighting()
end

-- function onStop()
-- 	return team.onStop()
-- end

function onBattleMessage(message)
	return team.onBattleMessage(message)
end

function onDialogMessage(message)
	return team.onAntibanDialogMessage(message)
end

function onSystemMessage(message)
	return team.onSystemMessage(message)
end
