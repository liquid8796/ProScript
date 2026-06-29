-- Copyright © 2016 Silv3r <silv3r@proshine-bot.com>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Route 2 (near Viridian)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Viridian City and Route 2.]]

local team = require "../../Libs/teamlib"
local maxLv = 25

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
		if getMapName() == "Pokecenter Viridian" then
			moveToCell(9,22)
		elseif getMapName() == "Viridian City" then
			moveToCell(39,0)
		elseif getMapName() == "Route 2" then
			moveToGrass()
		end
	else
		if getMapName() == "Route 2" then
			moveToCell(9,130)
		elseif getMapName() == "Viridian City" then
			moveToCell(44,43)
		elseif getMapName() == "Pokecenter Viridian" then
			usePokecenter()
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
