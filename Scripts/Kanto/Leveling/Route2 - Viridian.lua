-- Copyright © 2016 Silv3r <silv3r@proshine-bot.com>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Route 2 (near Viridian)"
author = "Liquid"
description = [[This script will train the first pokémon of your team.
It will also try to capture shinies by throwing pokéballs.
Start anywhere between Viridian City and Route 2.]]

local team = require "teamlib"
local maxLv = 25

function onStart()
	return team.onStart(maxLv)
end

function onPathAction()
	if isPokemonUsable(1) and getPokemonHealthPercent(1) > 30 then
		if getMapName() == "Pokecenter Viridian" then
			moveToMap("Viridian City")
		elseif getMapName() == "Viridian City" then
			moveToMap("Route 2")
		elseif getMapName() == "Route 2" then
			moveToGrass()
		end
	else
		if getMapName() == "Route 2" then
			moveToMap("Viridian City")
		elseif getMapName() == "Viridian City" then
			moveToMap("Pokecenter Viridian")
		elseif getMapName() == "Pokecenter Viridian" then
			usePokecenter()
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
