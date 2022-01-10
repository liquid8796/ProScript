local listPokemon = require "listPokemon"

team = {}

function team.setTeamFightBattle()
	local opponentLevel = getOpponentLevel()
	local myPokemonLvl  = getPokemonLevel(getActivePokemonNumber())
	if opponentLevel >= myPokemonLvl then
		local requestedId, requestedLevel = getMaxLevelUsablePokemon()
		if requestedLevel > myPokemonLvl and requestedId ~= nil	then 
			return sendPokemon(requestedId) 
		end
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
function team.isTrainingOver()
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


return team