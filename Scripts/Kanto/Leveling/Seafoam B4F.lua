-- Copyright © 2018 Silv3r <silv3r@proshine-bot.com>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the LICENSE file for more details.

name = "Leveling: Seafoam B4F"
author = "Silv3r"
description = [[This script will train your entire team.
It will also try to capture shinies by throwing pokéballs.
Start next to the nurse on the map Seafoam B4F.
Remember that healing at the nurse costs $1500.]]

-- You can specify your own mount here if you want.
mounts = { "Red Bicycle", "Blue Bicycle", "Yellow Bicycle", "Green Bicycle" }

rectanglesCount = 6
rectangles = {
	{56, 10, 57, 16}, -- top-left
	{56, 14, 61, 14}, -- next to nurse
	{54, 17, 59, 18}, -- middle-left
	{54, 18, 55, 23}, -- middle
	{50, 24, 55, 25}, -- bottom, above exit
	{50, 31, 54, 32}  -- bottom
}

selectedRectangle = 0

local seafoamConfiguredGroundMountName = nil
local seafoamGroundMountMode = nil

function isUseMountForTrainEnabled()
	return getOption ~= nil and getOption(1) == true
end

function clearConfiguredSeafoamGroundMount(logMessage)
	if seafoamGroundMountMode ~= "disabled" then
		setMount("")
		seafoamGroundMountMode = "disabled"
		seafoamConfiguredGroundMountName = nil
		if logMessage ~= nil and logMessage ~= "" then
			log(logMessage)
		end
	end
end

function configureSeafoamGroundMountForMap(mapKind)
	local mapName = getMapName()
	for key, mount in ipairs(mounts) do
		if hasItem(mount) then
			if seafoamGroundMountMode ~= mapKind or seafoamConfiguredGroundMountName ~= mount then
				setMount(mount)
				seafoamGroundMountMode = mapKind
				seafoamConfiguredGroundMountName = mount
				log("Ground mount configured for "..mapKind.." map "..mapName..": "..mount)
			end
			return false
		end
	end

	if seafoamGroundMountMode ~= "unavailable-"..mapKind then
		seafoamGroundMountMode = "unavailable-"..mapKind
		seafoamConfiguredGroundMountName = nil
		log("No ground mount item found for "..mapKind.." map "..mapName..".")
	end
	return false
end

function configureSeafoamGroundMountForTravel()
	return configureSeafoamGroundMountForMap("travel")
end

function configureSeafoamGroundMountForTraining()
	return configureSeafoamGroundMountForMap("training/encounter")
end

function onStart()
	setOptionName(1, "Use mount for train")
	selectRandomRectangle()
end

function disMountGroundIfNeeded()
	if isMounted ~= nil and isMounted() and (isSurfing == nil or not isSurfing()) then
		if disMount ~= nil then
			return disMount()
		end
		log("Ground mount is active but disMount() API is not available in this tool version.")
	end
	return false
end

function setMountForSeafoamTrainingMap()
	if getMapName() == "Seafoam B4F" then
		if isUseMountForTrainEnabled() then
			return configureSeafoamGroundMountForTraining()
		end

		clearConfiguredSeafoamGroundMount("Ground mount disabled on training/encounter map Seafoam B4F. Enable option 1 `Use mount for train` to keep using a ground mount here.")
		return disMountGroundIfNeeded()
	end

	return configureSeafoamGroundMountForTravel()
end

function onPathAction()
	if setMountForSeafoamTrainingMap() then
		return
	end
	if placeTrainingPokemonOnTop() then
		return
	end
	if giveLeftoversToFirstPokemon() then
		return
	end
	if getUsablePokemonCount() > 1 then
		if getMapName() == "Seafoam B4F" then
			moveToRectangle(
				rectangles[selectedRectangle][1],
				rectangles[selectedRectangle][2],
				rectangles[selectedRectangle][3],
				rectangles[selectedRectangle][4]
			)
		end
	else
		if getMapName() == "Seafoam B4F" then
			if getMoney() >= 1500 then
				talkToNpcOnCell(59, 13)
			end
		end
	end
end

function onBattleAction()
	if isWildBattle() and isOpponentShiny() then
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
			return
		end
	end
	if getUsablePokemonCount() > 1 then
		return attack() or sendUsablePokemon() or run() or sendAnyPokemon() or useAnyMove()
	else
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon() or useAnyMove()
	end
end

function onDialogMessage(message)
	-- Switch rectangle after each healing.
	if stringContains(message, "take care of them") then
		selectRandomRectangle()
	end
end

function selectRandomRectangle()
	selectedRectangle = math.random(1, rectanglesCount)
	log("Using rectangle " .. selectedRectangle .. ".")
end

function placeTrainingPokemonOnTop()
	if getTeamSize() < 1 then
		return false
	end
	local bestIndex = -1
	local minLevel = 1000
	local teamSize = getTeamSize()
	for i=1,teamSize do
		local level = getPokemonLevel(i)
		if isPokemonUsable(i) and level < minLevel then
			minLevel = level
			bestIndex = i
		end
	end
	if bestIndex != 1 then
		swapPokemon(1, bestIndex)
		return true
	end
	return false
end

function giveLeftoversToFirstPokemon()
	if getTeamSize() < 1 then
		return false
	end
	if getPokemonHeldItem(1) != nil then
		return false
	end
	if hasItem("Leftovers") then
		return giveItemToPokemon("Leftovers", 1)
	end
	local teamSize = getTeamSize()	
	for i=1,teamSize do
		if getPokemonHeldItem(i) == "Leftovers" then
			return takeItemFromPokemon(i)
		end
	end
	return false
end
