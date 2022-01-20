
name = "Leveling: Graveyard (near Vermilion)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Vermilion City and Vermilion City Graveyard.]]

local team = require "teamlib"
local start_flag = true
local end_flag = true
local maxLv = 50

function onStart()
	return team.onStart(maxLv)
end

function onPathAction()
	while not isTeamSortedByLevelAscending() and getOption(4) do
		return sortTeamByLevelAscending()
	end
	if team.isTrainingOver(maxLv) and not team.isSearching() then
		return logout("Complete training! Stop the bot.")
	end
	if getUsablePokemonCount() > 1 
		and (getPokemonLevel(team.getLowestIndexOfUsablePokemon()) < maxLv
		or team.isSearching())
	then
		if getMapName() == "Pokecenter Vermilion" then
			moveToCell(9,22)
		elseif getMapName() == "Vermilion City" then
			if start_flag or (getPlayerX()==27 and getPlayerY()==21) then
				start_flag = false
				moveToCell(36,22)
			elseif getPlayerX()==36 and getPlayerY()==22 then
				moveToCell(36,19)
			elseif getPlayerX()==36 and getPlayerY()==19 then
				moveToCell(38,19)
			elseif getPlayerX()==38 and getPlayerY()==19 then
				moveToCell(38,11)
			elseif getPlayerX()==38 and getPlayerY()==11 then
				moveToCell(43,11)
			elseif getPlayerX()==43 and getPlayerY()==11 then
				moveToCell(43,0)
			end
		elseif getMapName() == "Route 6" then
			moveToCell(0,52)
		elseif getMapName() == "Vermilion City Graveyard" then
			moveToGrass()
		elseif getMapName() == "Prof. Antibans Classroom" then
			if useItem("Escape Rope") then
				return
			end
			log("Quiz detected, talking to the prof.")
			pushDialogAnswer(1)
			talkToNpc("Prof. Antiban")
		end
	else
		if getMapName() == "Vermilion City Graveyard" then
			moveToCell(60,33)
		elseif getMapName() == "Route 6" then
			moveToCell(23,61)
		elseif getMapName() == "Vermilion City" then
			if end_flag or (getPlayerX()==23 and getPlayerY()==61) then
				end_flag = false
				moveToCell(43,11)
			elseif getPlayerX()==43 and getPlayerY()==11 then
				moveToCell(38,11)
			elseif getPlayerX()==38 and getPlayerY()==11 then
				moveToCell(38,22)
			elseif getPlayerX()==38 and getPlayerY()==22 then
				moveToCell(27,21)
			end
		elseif getMapName() == "Pokecenter Vermilion" then
			usePokecenter()
		elseif getMapName() == "Prof. Antibans Classroom" then
			if useItem("Escape Rope") then
				return
			end
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
