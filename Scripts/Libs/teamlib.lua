local listPokemon = require "../../Libs/listPokemon"
local ev = require "../../Libs/listEVs"
local mountList = require "../../Libs/mountList"
local timeLeft = 0
local listPokemonSavePath = "Scripts/Libs/listPokemon.lua"
local huntCatchHpThreshold = 70
local huntWeakenMaxLevelGap = 4
local huntWeakenMaxAttempts = 3
local autoBuyPokeballMoneyThreshold = 30000
local autoBuyPokeballTargetCount = 150
local autoBuyPokeballPrice = 200
local autoBuyPokeballLastLogKey = nil
local weakenTargetKey = nil
local weakenLastHealthPercent = nil
local weakenAttemptCount = 0

team = {}
local ran = 1
local isMount = true
local isMoveBlocked = false
local isCanSwitch = true

local kantoTrainingMaps = {
	["Cinnabar mansion 1"] = true,
	["Mt. Moon 1F"] = true,
	["Mt. Moon B1F"] = true,
	["Rock Tunnel 1"] = true,
	["Rock Tunnel 2"] = true,
	["Route 1"] = true,
	["Route 2"] = true,
	["Route 3"] = true,
	["Route 4"] = true,
	["Route 5"] = true,
	["Route 6"] = true,
	["Route 7"] = true,
	["Route 8"] = true,
	["Route 9"] = true,
	["Route 10"] = true,
	["Route 11"] = true,
	["Route 18"] = true,
	["Route 20"] = true,
	["Route 21"] = true,
	["Route 22"] = true,
	["Route 25"] = true,
	["Seafoam B4F"] = true,
	["Vermilion City Graveyard"] = true,
	["Victory Road Kanto 3F"] = true,
	["Viridian Forest"] = true,
}

local kantoPokemartMaps = {
	["Viridian Pokemart"] = true,
	["Pewter Pokemart"] = true,
	["Cerulean Pokemart"] = true,
	["Vermilion Pokemart"] = true,
	["Lavender Pokemart"] = true,
	["Fuchsia Pokemart"] = true,
	["Cinnabar Pokemart"] = true,
	["Celadon Mart 2"] = true,
}

local kantoPokemartExitRoutes = {
	["Viridian Pokemart"] = { x = 4, y = 11, target = "Viridian City" },
	["Lavender Pokemart"] = { x = 4, y = 11, target = "Lavender Town" },
	["Cinnabar Pokemart"] = { x = 4, y = 11, target = "Cinnabar Island" },
	["Celadon Mart 2"] = { x = 1, y = 4, target = "Celadon Mart 1" },
	["Celadon Mart 1"] = { x = 8, y = 15, target = "Celadon City" },
}

local kantoAutoBuyPokeballRoutes = {
	["Player Bedroom Pallet"] = { x = 12, y = 4, target = "Player House Pallet" },
	["Player House Pallet"] = { x = 4, y = 10, target = "Pallet Town" },
	["Pallet Town"] = { x = 14, y = 0, target = "Route 1" },
	["Route 1"] = { x = 13, y = 4, target = "Viridian City" },
	["Route 1 Stop House"] = { x = 3, y = 2, target = "Viridian City" },
	["Viridian City"] = { x = 54, y = 34, target = "Viridian Pokemart" },
	["Pokecenter Viridian"] = { x = 9, y = 22, target = "Viridian City" },
	["Route 22"] = { x = 60, y = 11, target = "Viridian City" },
	["Route 2 Stop2"] = { x = 4, y = 2, target = "Route 2" },
	["Viridian Forest"] = { x = 12, y = 15, target = "Route 2 Stop2" },
	["Pewter City"] = { x = 37, y = 26, target = "Pewter Pokemart" },
	["Pokecenter Pewter"] = { x = 9, y = 22, target = "Pewter City" },
	["Route 3"] = { x = 0, y = 21, target = "Pewter City" },
	["Pokecenter Route 3"] = { x = 9, y = 22, target = "Route 3" },
	["Mt. Moon 1F"] = { x = 38, y = 63, target = "Route 3" },
	["Cerulean City"] = { x = 24, y = 40, target = "Cerulean Pokemart" },
	["Pokecenter Cerulean"] = { x = 9, y = 22, target = "Cerulean City" },
	["Route 4"] = { x = 96, y = 22, target = "Cerulean City" },
	["Route 5"] = { x = 28, y = 0, target = "Cerulean City" },
	["Route 24"] = { x = 14, y = 31, target = "Cerulean City" },
	["Route 25"] = { x = 15, y = 30, target = "Route 24" },
	["Vermilion City"] = { x = 47, y = 37, target = "Vermilion Pokemart" },
	["Pokecenter Vermilion"] = { x = 9, y = 22, target = "Vermilion City" },
	["Route 6"] = { x = 23, y = 61, target = "Vermilion City" },
	["Route 11"] = { x = 0, y = 14, target = "Vermilion City" },
	["Vermilion City Graveyard"] = { x = 60, y = 33, target = "Route 6" },
	["Lavender Town"] = { x = 3, y = 5, target = "Lavender Pokemart" },
	["Pokecenter Lavender"] = { x = 9, y = 22, target = "Lavender Town" },
	["Route 8"] = { map = "Lavender Town", target = "Lavender Town" },
	["Celadon City"] = { x = 24, y = 20, target = "Celadon Mart 1" },
	["Pokecenter Celadon"] = { map = "Celadon City", target = "Celadon City" },
	["Route 7"] = { map = "Celadon City", target = "Celadon City" },
	["Celadon Mart 1"] = { x = 1, y = 4, target = "Celadon Mart 2" },
	["Fuchsia City"] = { x = 15, y = 18, target = "Fuchsia Pokemart" },
	["Pokecenter Fuchsia"] = { x = 9, y = 22, target = "Fuchsia City" },
	["Route 18"] = { x = 50, y = 17, target = "Fuchsia City" },
	["Cinnabar Island"] = { x = 25, y = 24, target = "Cinnabar Pokemart" },
	["Pokecenter Cinnabar"] = { map = "Cinnabar Island", target = "Cinnabar Island" },
	["Route 20"] = { map = "Cinnabar Island", target = "Cinnabar Island" },
	["Route 21"] = { map = "Cinnabar Island", target = "Cinnabar Island" },
	["Cinnabar mansion 1"] = { map = "Cinnabar Island", target = "Cinnabar Island" },
}

local function isAutoBuyPokeballEnabled()
	return getOption ~= nil and getOption(7) == true
end

local function getPokeballCount()
	local count = 0
	if getItemQuantity ~= nil then
		count = tonumber(getItemQuantity("Pokeball")) or 0
		local accentCount = tonumber(getItemQuantity("Pokéball")) or 0
		if accentCount > count then
			count = accentCount
		end
	end
	return count
end

local function logAutoBuyPokeball(messageKey, message)
	if autoBuyPokeballLastLogKey ~= messageKey then
		autoBuyPokeballLastLogKey = messageKey
		log(message)
	end
end

local function clearAutoBuyPokeballLogState()
	autoBuyPokeballLastLogKey = nil
end

local function getRoute2AutoBuyRoute()
	if getPlayerY ~= nil then
		local y = tonumber(getPlayerY())
		if y ~= nil and y < 65 then
			return { x = 25, y = 0, target = "Pewter City" }
		end
	end
	return { x = 9, y = 130, target = "Viridian City" }
end

local function handleAutoBuyPokeballInMart(mapName, pokeballCount)
	if not isShopOpen() then
		logAutoBuyPokeball("open-shop-"..mapName, "Auto buy pokeball: opening shop in "..mapName..".")
		if mapName == "Celadon Mart 2" then
			return talkToNpcOnCell(4, 8)
		end
		return talkToNpcOnCell(3, 5)
	end

	if hasShopItem("Pokeball") then
		local buyAmount = autoBuyPokeballTargetCount - pokeballCount
		local maxBuyable = math.floor(getMoney() / autoBuyPokeballPrice)
		buyAmount = math.min(buyAmount, maxBuyable)
		if buyAmount > 0 then
			logAutoBuyPokeball("buy-"..mapName.."-"..buyAmount, "Auto buy pokeball: buying "..buyAmount.." Pokeball(s) in "..mapName..".")
			return buyItem("Pokeball", buyAmount)
		end
	end

	logAutoBuyPokeball("shop-no-pokeball-"..mapName, "Auto buy pokeball: Pokeball is not available in "..mapName..".")
	return false
end

local function leaveKantoPokemartIfNeeded(mapName, reason)
	local route = kantoPokemartExitRoutes[mapName]
	if route == nil and kantoPokemartMaps[mapName] == true then
		route = { x = 6, y = 12, target = "outside" }
	end
	if route == nil then
		return false
	end

	logAutoBuyPokeball("leave-"..mapName.."-"..tostring(reason), "Auto buy pokeball: leaving "..mapName.." after "..tostring(reason)..".")
	return moveToCell(route.x, route.y)
end

function team.autoBuyPokeballIfNeeded()
	if not isAutoBuyPokeballEnabled() then
		clearAutoBuyPokeballLogState()
		return false
	end

	local mapName = getMapName()
	local pokeballCount = getPokeballCount()
	if pokeballCount > 0 then
		if leaveKantoPokemartIfNeeded(mapName, "buying or already having Pokeball") then
			return true
		end
		clearAutoBuyPokeballLogState()
		return false
	end

	if getMoney() < autoBuyPokeballMoneyThreshold then
		if leaveKantoPokemartIfNeeded(mapName, "insufficient money") then
			return true
		end
		logAutoBuyPokeball("not-enough-money", "Auto buy pokeball skipped: inventory has 0 Pokeball but money is below $"..autoBuyPokeballMoneyThreshold..".")
		return false
	end

	if kantoPokemartMaps[mapName] == true then
		return handleAutoBuyPokeballInMart(mapName, pokeballCount)
	end

	local route = kantoAutoBuyPokeballRoutes[mapName]
	if mapName == "Route 2" then
		route = getRoute2AutoBuyRoute()
	end

	if route ~= nil then
		logAutoBuyPokeball("route-"..mapName.."-"..tostring(route.target), "Auto buy pokeball: inventory has 0 Pokeball and money >= $"..autoBuyPokeballMoneyThreshold..". Going to "..tostring(route.target)..".")
		if route.map ~= nil and moveToMap ~= nil then
			return moveToMap(route.map)
		end
		return moveToCell(route.x, route.y)
	end

	logAutoBuyPokeball("unsupported-"..mapName, "Auto buy pokeball: no Kanto Pokemart route configured from "..mapName..".")
	return false
end

local configuredGroundMountName = nil
local groundMountMode = nil

local function isUseMountForTrainEnabled()
	return getOption ~= nil and getOption(6) == true
end

local function clearConfiguredGroundMount(logMessage)
	if groundMountMode ~= "disabled" then
		setMount("")
		groundMountMode = "disabled"
		configuredGroundMountName = nil
		if logMessage ~= nil and logMessage ~= "" then
			log(logMessage)
		end
	end
end

local function configureGroundMountForMap(mapName, mapKind)
	if not isMount then
		return false
	end

	for key, mount in ipairs(mountList) do
		if hasItem(mount) then
			if groundMountMode ~= mapKind or configuredGroundMountName ~= mount then
				setMount(mount)
				groundMountMode = mapKind
				configuredGroundMountName = mount
				log("Ground mount configured for "..mapKind.." map "..mapName..": "..mount)
			end
			return false
		end
	end

	if groundMountMode ~= "unavailable-"..mapKind then
		groundMountMode = "unavailable-"..mapKind
		configuredGroundMountName = nil
		log("No ground mount item found for "..mapKind.." map "..mapName..".")
	end
	return false
end

local function configureGroundMountForTravel(mapName)
	return configureGroundMountForMap(mapName, "travel")
end

local function configureGroundMountForTraining(mapName)
	return configureGroundMountForMap(mapName, "training/encounter")
end

function team.onStart(maxLv)
	setOptionName(1, "Auto restart")
	setOptionName(2, "EVs training")
	setOptionName(3, "Only search")
	setOptionName(4, "Sorting mode")
	setOption(4, true)
	setOptionName(5, "Team combat")
	setOption(5, true)
	setOptionName(6, "Use mount for train")
	setOptionName(7, "Auto buy pokeball")
	--closeAllChannel()
	log("Training pokemon until reach level "..maxLv)
	--for longer botting runs
	-- return disablePrivateMessage()
	return
end

function team.isKantoTrainingMap(mapName)
	return kantoTrainingMaps[mapName] == true
end

function team.disMountGroundIfNeeded()
	if isMounted ~= nil and isMounted() and (isSurfing == nil or not isSurfing()) then
		if disMount ~= nil then
			return disMount()
		end
		log("Ground mount is active but disMount() API is not available in this tool version.")
	end
	return false
end

function team.setMountForTrainingMap(trainingMaps)
	local mapName = getMapName()
	local maps = trainingMaps or kantoTrainingMaps

	if team.autoBuyPokeballIfNeeded() then
		return true
	end

	if maps[mapName] == true then
		if isUseMountForTrainEnabled() then
			return configureGroundMountForTraining(mapName)
		end

		clearConfiguredGroundMount("Ground mount disabled on training/encounter map "..mapName..". Enable option 6 `Use mount for train` to keep using a ground mount here.")
		return team.disMountGroundIfNeeded()
	end

	return configureGroundMountForTravel(mapName)
end

local function resetWeakenTracking()
	weakenTargetKey = nil
	weakenLastHealthPercent = nil
	weakenAttemptCount = 0
end

local function shouldStopWeakening(opponentName, opponentLevel, healthPercent)
	local targetKey = tostring(opponentName or "")..":"..tostring(opponentLevel or "")
	local hpBucket = nil
	if healthPercent ~= nil then
		hpBucket = math.floor(tonumber(healthPercent) or healthPercent)
	end

	if weakenTargetKey ~= targetKey then
		weakenTargetKey = targetKey
		weakenLastHealthPercent = hpBucket
		weakenAttemptCount = 0
	end

	if hpBucket ~= nil and weakenLastHealthPercent ~= nil and hpBucket < weakenLastHealthPercent then
		weakenLastHealthPercent = hpBucket
		weakenAttemptCount = 0
	else
		weakenLastHealthPercent = hpBucket
		weakenAttemptCount = weakenAttemptCount + 1
	end

	return weakenAttemptCount > huntWeakenMaxAttempts
end

function team.onBattleFighting()
	local isTeamUsable = getTeamSize() == 1 --if it's our starter, it has to atk
		or getUsablePokemonCount() > 1		--otherwise we atk, as long as we have 2 usable pkm	
	if isTeamUsable then
		local huntCondition = isWildBattle() and (isOpponentShiny() or team.isInListPokemon(listPokemon, getOpponentName()))
		local opponentLevel = getOpponentLevel()
		local myPokemonLvl  = getPokemonLevel(getActivePokemonNumber())
		if isMoveBlocked then
			return team.antiMoveBlocked()
		end
		if not isCanSwitch then
			if sendUsablePokemon() or sendAnyPokemon() or useAnyMove() or run() then
				isCanSwitch = true
				return
			end
		end
		if getOption(3) and huntCondition then
			return team.doOnlySearchHunting()
		elseif getOption(3) and not huntCondition then
			return team.defeatOnlySearchNonTarget()
		end
		if opponentLevel >= myPokemonLvl and getOption(5) and not huntCondition then
			local requestedId, requestedLevel = team.getMaxLevelUsablePokemon()
			if requestedLevel > myPokemonLvl and requestedId ~= nil	then 
				return sendPokemon(requestedId) 
			end
		end	
		if getOption(2) then
			local listEVs = ev.getListEVs("Atk")
			if team.isInList(listEVs, getOpponentName()) or huntCondition then
				return team.doHunting(huntCondition)
			else
				return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
			end
		end
		return team.doHunting(huntCondition)
	else
		--relog(1,"Restart for healing!")
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
	end
end

function team.getOpponentHealthPercentSafe()
	if getOpponentHealthPercent ~= nil then
		local healthPercent = tonumber(getOpponentHealthPercent())
		if healthPercent ~= nil then
			return healthPercent
		end
	end

	if getOpponentHealth ~= nil and getOpponentMaxHealth ~= nil then
		local health = tonumber(getOpponentHealth())
		local maxHealth = tonumber(getOpponentMaxHealth())
		if health ~= nil and maxHealth ~= nil and maxHealth > 0 then
			return (health * 100) / maxHealth
		end
	end

	return nil
end

function team.shouldWeakenBeforeCatch()
	local healthPercent = team.getOpponentHealthPercentSafe()
	return healthPercent ~= nil and healthPercent >= huntCatchHpThreshold
end

function team.isPokemonLevelSafeToWeaken(pokemonId, opponentLevel)
	local pokemonLevel = tonumber(getPokemonLevel(pokemonId))
	opponentLevel = tonumber(opponentLevel)
	if pokemonLevel == nil or opponentLevel == nil then
		return false
	end
	local levelGap = pokemonLevel - opponentLevel
	return levelGap > 0 and levelGap <= huntWeakenMaxLevelGap
end

function team.findSafeWeakenPokemon(opponentLevel)
	opponentLevel = tonumber(opponentLevel)
	if opponentLevel == nil then
		return nil, nil
	end

	local bestId = nil
	local bestLevel = nil
	for pokemonId=1, getTeamSize(), 1 do
		if pokemonId ~= getActivePokemonNumber()
			and isPokemonUsable(pokemonId)
			and team.isPokemonLevelSafeToWeaken(pokemonId, opponentLevel) then
			local pokemonLevel = tonumber(getPokemonLevel(pokemonId))
			if bestLevel == nil or pokemonLevel < bestLevel then
				bestId = pokemonId
				bestLevel = pokemonLevel
			end
		end
	end
	return bestId, bestLevel
end

function team.throwCatchBall(opponentName)
	if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokéball") or useItem("Pokeball") then
		log("Try to catch "..opponentName)
		return true
	end

	log("No usable Pokeball found for hunted Pokemon "..opponentName..".")
	return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
end


function team.defeatOnlySearchNonTarget()
	local opponentName = getOpponentName()
	log("Only search: defeating non-target "..tostring(opponentName).." instead of running away.")
	return attack() or useAnyMove() or sendUsablePokemon() or sendAnyPokemon()
end

function team.doOnlySearchHunting()
	local opponentName = getOpponentName()
	local opponentLevel = tonumber(getOpponentLevel())
	local activePokemonId = getActivePokemonNumber()
	local activePokemonLevel = tonumber(getPokemonLevel(activePokemonId))
	local healthPercent = team.getOpponentHealthPercentSafe()

	if not team.shouldWeakenBeforeCatch() then
		resetWeakenTracking()
		return team.throwCatchBall(opponentName)
	end

	if team.isPokemonLevelSafeToWeaken(activePokemonId, opponentLevel) then
		if shouldStopWeakening(opponentName, opponentLevel, healthPercent) then
			log("Weakening "..opponentName.." did not lower HP after "..huntWeakenMaxAttempts.." attempts. Throwing ball to avoid battle stuck.")
			return team.throwCatchBall(opponentName)
		end

		if healthPercent ~= nil then
			log("Weakening "..opponentName.." before catch (HP "..math.floor(healthPercent).."%, active Lv "..activePokemonLevel..", opponent Lv "..opponentLevel..").")
		else
			log("Weakening "..opponentName.." before catch (active Lv "..activePokemonLevel..", opponent Lv "..opponentLevel..").")
		end

		if attack() or useAnyMove() then
			return true
		end

		log("No weakening move could be used against "..opponentName..". Throwing ball to avoid battle stuck.")
		return team.throwCatchBall(opponentName)
	end

	local safePokemonId, safePokemonLevel = team.findSafeWeakenPokemon(opponentLevel)
	if safePokemonId ~= nil then
		log("Switching to Pokemon #"..safePokemonId.." Lv "..safePokemonLevel.." to weaken "..opponentName.." safely before catch.")
		return sendPokemon(safePokemonId)
	end

	resetWeakenTracking()
	log("No usable team Pokemon has level greater than "..opponentName.." by 1-"..huntWeakenMaxLevelGap.." levels. Throwing ball immediately.")
	return team.throwCatchBall(opponentName)
end

function team.doHunting(hunt_condition)
	if hunt_condition then		
		if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokéball") or useItem("Pokeball") then
			return true
		else
			return attack() or sendUsablePokemon() or sendAnyPokemon() or run() 
		end
	else
		return attack() or useAnyMove() or sendUsablePokemon() or sendAnyPokemon() or run()
	end	
end

function team.isSearching()
	return getOption(3)
end

function team.antiMoveBlocked()
	if isWildBattle() then
		if run() or sendAnyPokemon() or useAnyMove() then
			isMoveBlocked = false
			return log("Unstuck from battle")
		else
			log("Stuck in battle")
		end
	else
		if sendUsablePokemon() or sendAnyPokemon() or useAnyMove() then
			isMoveBlocked = false
			return log("Unstuck from battle")
		else
			log("Stuck in battle")
		end
	end	
end

function team.getLowestIndexOfUsablePokemon()
	local size = getTeamSize()
	for i=1,size do
		if isPokemonUsable(i) then
			return i
		end
	end
	return size
end
function team.isTrainingOver(maxLv)
	if team.isSearching() then
		return false
	end

	local count = 0
	local size = getTeamSize()
	for i=1,size do
		if getPokemonLevel(i) >= maxLv then
			count = count + 1
		end
	end
	return count >= size
end
function team.getMaxLevelUsablePokemon()
	local currentId
	local currentLevel
	for pokemonId=1, getTeamSize(), 1 do
		local pokemonLevel = getPokemonLevel(pokemonId)
		if  (currentLevel == nil or pokemonLevel > currentLevel)
			and isPokemonUsable(pokemonId) then
			currentLevel = pokemonLevel
			currentId    = pokemonId
		end
	end
	return currentId, currentLevel
end
function team.addListToFile(list, path)
	local line = "local listPokemon = \n{"
	for key, value in pairs(list) do		
        line = line .. "\n['"..key.."']="..value..","
    end
	line = line .. "\n}\nreturn listPokemon"
	writeToFile(path, line, true)
end
function team.isInListPokemon(list, val)
    for key, value in pairs(list) do		
        if key == val and value < 2 then
            return true
        end
    end
    return false
end
function team.isInList(list, val)
	for key, value in ipairs(list) do		
        if value == val then
            return true
        end
    end
	return false
end
function split(str, sep)
   local result = {}
   local regex = ("([^%s]+)"):format(sep)
   for each in str:gmatch(regex) do
      table.insert(result, each)
   end
   return result
end
function team.getFirstUsablePokemon()
	for i=1, getTeamSize(), 1 do
		if isPokemonUsable(i) then
			return i
		end
	end
	return 0
end
function team.getPokemonIdWithItem(ItemName)	
	for i=1, getTeamSize(), 1 do
		if getPokemonHeldItem(i) == ItemName then
			return i
		end
	end
	return 0
end
function team.useLeftovers()
	ItemName = "Leftovers"
	local PokemonNeedLeftovers = team.getFirstUsablePokemon()
	local PokemonWithLeftovers = team.getPokemonIdWithItem(ItemName)
	
	if getTeamSize() > 0 then
		if PokemonWithLeftovers > 0 then
			if PokemonNeedLeftovers == PokemonWithLeftovers  then
				return false -- now leftovers is on rightpokemon
			else
				takeItemFromPokemon(PokemonWithLeftovers)
				return true
			end
		else

			if hasItem(ItemName) and PokemonNeedLeftovers ~= 0 then
				giveItemToPokemon(ItemName,PokemonNeedLeftovers)
				return true
			else
				return false
			end
		end
	else
		return false
	end
end
function team.delay(waitTime)
    timer = os.time()
	log((waitTime-os.time()-timer).."s remaining...")
    repeat until os.time() > timer + waitTime
end

function team.onBattleMessage(message)
	if stringContains(message, "This move is disabled") then
		isMoveBlocked = true
	end
	if stringContains(message, "You can not switch this Pokemon") then
		isCanSwitch = false
	end
	if stringContains(message, "fainted") or stringContains(message, "ran away") or stringContains(message, "You have fled") then
		resetWeakenTracking()
	end
	if stringContains(message, "caught") and not isOpponentShiny() then
		resetWeakenTracking()
		local pokemonName = getOpponentName()
		listPokemon[pokemonName] = (listPokemon[pokemonName] or 0) + 1
		log(getItemQuantity("Pokeball").." pokeballs left")
		team.addListToFile(listPokemon, listPokemonSavePath)
	end
end
function team.onStop()
	if getOption(1) then
		return restart(5,"Restart bot after 5s")
	else
		return
	end
end
function team.antibanclassroom()
	if useItem("Escape Rope") then
		return
	end
	log("Quiz detected, talking to the prof.")
	pushDialogAnswer(1)
	talkToNpc("Prof. Antiban")
end
antibanQuestions = {

["What type is Flygon?"] = "Dragon/Ground",
["How many Pokemon can Eevee currently evolve into?"] = "8",
["Which of these are effective against Dragon?"] = "Dragon",
["What level does Litleo evolve into Pyroar?"] = "35",
["Articuno is one of the legendary birds of Kanto."] = "True",

}

function team.onAntibanDialogMessage(message)
	if getMapName() == "Prof. Antibans Classroom" then
		if stringContains(message, "incorrect") then
			log("Could not answer correctly, try another answer.")
			if ran < 3 then
				pushDialogAnswer(ran+1)
			else
				ran = 1
				pushDialogAnswer(ran)
			end
		else
			pushDialogAnswer(ran)
		end
	end
end

function team.onSystemMessage(message)
	if stringContains(message, "Bot still stuck") then
		return relog(5,"Relog in 5s.")
	end
end

function closeAllChannel()
	closeChannel("All")
	closeChannel("Trade")
	closeChannel("Battle")
	closeChannel("Other")
	closeChannel("Help")
end

return team