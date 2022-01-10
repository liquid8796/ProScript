
name = "Leveling: Route 2 (near Pewter)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Pewter City and Route 2.]]

local team = require "teamlib"
local maxLv = 18

function onStart()
	setOptionName(1, "Auto relog")
	setMount("Latios Mount")
	log("Training pokemon until reach level "..maxLv)
	--for longer botting runs
	return disablePrivateMessage()
end

function onPathAction()
	while not isTeamSortedByLevelAscending() do
		return sortTeamByLevelAscending()
	end
	if team.isTrainingOver(maxLv) then
		fatal("Complete training! Stop the bot.")
	end
	if getUsablePokemonCount() > 1 and getPokemonLevel(team.getLowestIndexOfUsablePokemon()) < maxLv then
		if getMapName() == "Pokecenter Pewter" then
			moveToCell(9,22)
		elseif getMapName() == "Pewter City" then
			moveToCell(16,55)
		elseif getMapName() == "Route 2" then
			moveToGrass()
		elseif getMapName() == "Prof. Antibans Classroom" then
			log("Quiz detected, talking to the prof.")
			talkToNpc("Prof. Antiban")
		end
	else
		if getMapName() == "Route 2" then
			moveToCell(25,0)
		elseif getMapName() == "Pewter City" then
			moveToCell(24,35)
		elseif getMapName() == "Pokecenter Pewter" then
			usePokecenter()
		elseif getMapName() == "Prof. Antibans Classroom" then
			log("Quiz detected, talking to the prof.")
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
