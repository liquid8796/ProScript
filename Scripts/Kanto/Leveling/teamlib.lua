local listPokemon = require "listPokemon"
local mountList = require "mountList"
local timeLeft = 0

team = {}
local ran = 1
local isMount = false
local only_search = false

function team.onStart(maxLv)
	setOptionName(1, "Auto relog")
	setOptionName(2, "EVs training")
	if isMount then
		for key, mount in ipairs(mountList) do
			if hasItem(mount) then
				setMount(mount)
				break
			end
		end
	end
	log("Training pokemon until reach level "..maxLv)
	--for longer botting runs
	return disablePrivateMessage()
end

function team.onBattleFighting()
	local isTeamUsable = getTeamSize() == 1 --if it's our starter, it has to atk
		or getUsablePokemonCount() > 1		--otherwise we atk, as long as we have 2 usable pkm	
	if isTeamUsable then
		local huntCondition = isWildBattle() and (isOpponentShiny() or (team.isInListPokemon(listPokemon, getOpponentName()) and getOpponentLevel() >= 5))
		local opponentLevel = getOpponentLevel()
		local myPokemonLvl  = getPokemonLevel(getActivePokemonNumber())
		if only_search and huntCondition then
			fatal("Found your desired pokemon!")
		end
		if opponentLevel >= myPokemonLvl and not huntCondition then
			local requestedId, requestedLevel = team.getMaxLevelUsablePokemon()
			if requestedLevel > myPokemonLvl and requestedId ~= nil	then 
				return sendPokemon(requestedId) 
			end
		end		
		if getOption(2) then
			if getOpponentName() == "Paras" then
				return attack() or sendUsablePokemon() or sendAnyPokemon() or run()
			else
				return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
			end
		end
		if huntCondition then		
			if useItem("Ultra Ball") or useItem("Great Ball") or useItem("Pokeball") then
				return
			else
				return attack() or sendUsablePokemon() or sendAnyPokemon() or run() 
			end
		else
			return attack() or sendUsablePokemon() or sendAnyPokemon() or run()
		end
	else
		--relog(1,"Restart for healing!")
		return run() or attack() or sendUsablePokemon() or sendAnyPokemon()
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
	local count = 0
	local size = getTeamSize()
	for i=1,size do
		if getPokemonLevel(i) >= maxLv then
			count = count + 1
		end
	end
	if count < size then return false end
	return true
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
function team.split(str, sep)
   local result = {}
   local regex = ("([^%s]+)"):format(sep)
   for each in str:gmatch(regex) do
      table.insert(result, each)
   end
   return result
end
function team.delay(waitTime)
    timer = os.time()
	log((waitTime-os.time()-timer).."s remaining...")
    repeat until os.time() > timer + waitTime
end


function team.onBattleMessage(message)
	if stringContains(message, "caught") and not isOpponentShiny() then
		listPokemon[getOpponentName()] = listPokemon[getOpponentName()] + 1
		log(getItemQuantity("Pokeball").." pokeballs left")
		team.addListToFile(listPokemon, "D:\\ProScript\\Scripts\\Kanto\\Leveling\\listPokemon.lua")
		--team.addListToFile(listPokemon, "C:\\PRO_Script\\Scripts\\Kanto\\Leveling\\listPokemon.lua")
	end
end

antibanQuestions = {

["What type is Flygon?"] = "Dragon/Ground",
["How many Pokemon can Eevee currently evolve into?"] = "8",
["Which of these are effective against Dragon?"] = "Dragon",
["What level does Litleo evolve into Pyroar?"] = "35",
["Articuno is one of the legendary birds of Kanto."] = "True",

}

function team.onAntibanDialogMessage(message)
	--[[if getMapName() ~= "Prof. Antibans Classroom" then
		return
	end
	if stringContains(message, "incorrect") then
		fatal("Could not answer correctly, stopping the bot.")
	end
	for key, value in pairs(antibanQuestions) do
		if stringContains(message, key) then
			pushDialogAnswer(value)
		end
	end--]]
	--[[if getMapName() ~= "Prof. Antibans Classroom" then
		return
	end--]]
	--[[if stringContains(message, "take care of") then
		timeLeft = timeLeft + 1
		local n = 1
		if timeLeft > 1 then 
			timeLeft = 0
			relog(5,"Restart 5s for amtiban!")
		else
			log("time remaining: "..(n-timeLeft))
		end
	end--]]
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

return team