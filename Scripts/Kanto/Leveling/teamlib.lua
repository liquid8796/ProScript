local listPokemon = require "listPokemon"

team = {}

function team.onBattleFighting()
	local isTeamUsable = getTeamSize() == 1 --if it's our starter, it has to atk
		or getUsablePokemonCount() > 1		--otherwise we atk, as long as we have 2 usable pkm
	if isTeamUsable and getOpponentName() == "Paras" then
		local opponentLevel = getOpponentLevel()
		local myPokemonLvl  = getPokemonLevel(getActivePokemonNumber())
		if opponentLevel >= myPokemonLvl then
			local requestedId, requestedLevel = team.getMaxLevelUsablePokemon()
			if requestedLevel > myPokemonLvl and requestedId ~= nil	then 
				return sendPokemon(requestedId) 
			end
		end
		if isWildBattle() and (isOpponentShiny() or (team.isInListPokemon(listPokemon, getOpponentName()))) then		
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
	for i=1,6 do
		if isPokemonUsable(i) then
			return i
		end
	end
	return 6
end
function team.isTrainingOver(maxLv)
	local count = 0
	for i=1,6 do
		if getPokemonLevel(i) >= maxLv then
			count = count + 1
		end
	end
	if count < 6 then return false end
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
function split(str, sep)
   local result = {}
   local regex = ("([^%s]+)"):format(sep)
   for each in str:gmatch(regex) do
      table.insert(result, each)
   end
   return result
end

function team.onBattleMessage(message)
	if stringContains(message, "caught") then
		listPokemon[getOpponentName()] = listPokemon[getOpponentName()] + 1
		--team.addListToFile(listPokemon, "D:\\ProScript\\Scripts\\Kanto\\Leveling\\listPokemon.lua")
		team.addListToFile(listPokemon, "C:\\PRO_Script\\Scripts\\Kanto\\Leveling\\listPokemon.lua")
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
	if getMapName() ~= "Prof. Antibans Classroom" then
		return
	end
	if stringContains(message, "incorrect") then
		fatal("Could not answer correctly, stopping the bot.")
	end
	for key, value in pairs(antibanQuestions) do
		if stringContains(message, key) then
			pushDialogAnswer(value)
		else
			pushDialogAnswer(1)
		end
	end
end

return team