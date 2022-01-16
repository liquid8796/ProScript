
name = "Leveling: Mt. Moon Entrance (near Route 3)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Route 3 and the entrance of the Mt. Moon.]]

local team = require "teamlib"
local maxLv = 20

function onStart()
	return team.onStart(maxLv)
end

function onPathAction()
	while not isTeamSortedByLevelAscending() do
		return sortTeamByLevelAscending()
	end
	if team.isTrainingOver(maxLv) and not team.isSearching() then
		return logout("Complete training! Stop the bot.")
	end
	if getUsablePokemonCount() > 1 
		and (getPokemonLevel(team.getLowestIndexOfUsablePokemon()) < maxLv
		or team.isSearching())
	then
		if getMapName() == "Pokecenter Route 3" then
			moveToCell(9,22)
		elseif getMapName() == "Route 3" then
			moveToCell(84,16)
		elseif getMapName() == "Mt. Moon 1F" then
			moveToNormalGround()
		elseif getMapName() == "Prof. Antibans Classroom" then
			log("Quiz detected, talking to the prof.")
			pushDialogAnswer(1)
			talkToNpc("Prof. Antiban")
		end
	else
		if getMapName() == "Mt. Moon 1F" then
			moveToCell(38,63)
		elseif getMapName() == "Route 3" then
			moveToCell(79,21)
		elseif getMapName() == "Pokecenter Route 3" then
			usePokecenter()
		elseif getMapName() == "Prof. Antibans Classroom" then
			log("Quiz detected, talking to the prof.")
			pushDialogAnswer(1)
			talkToNpc("Prof. Antiban")
		end
	end
end

function onBattleAction()
	return team.onBattleFighting()
end

function onStop()
	if getOption(1) then
		return relog(2,"Restart bot after 2s")
	else
		return
	end
end

function onBattleMessage(message)
	return team.onBattleMessage(message)
end

function onDialogMessage(message)
	return team.onAntibanDialogMessage(message)
end