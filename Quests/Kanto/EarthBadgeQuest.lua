-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local pc	 = require "Libs/pclib"
local game   = require "Libs/gamelib"
local team   = require "Libs/teamlib"
local Quest  = require "Quests/Quest"

local luaPokemonData = require "Data/luaPokemonData"

local name		  = 'Earth Badge'
local description = 'Beat Giovanni'

local EarthBadgeQuest = Quest:new()

function EarthBadgeQuest:new()
	local o = Quest.new(EarthBadgeQuest, name, description, level)
	o.checkedForBestPokemon = false
	return o
end

function EarthBadgeQuest:isDoable()
	if self:hasMap() and hasItem("Volcano Badge") and not hasItem("Zephyr Badge") then --Fixed DC on gym after win
		return true
	end
	return false
end

function EarthBadgeQuest:isDone()
	if (hasItem("Earth Badge") and getMapName() == "Route 22") or getMapName() == "Pokecenter Cinnabar" then --Fixed DC on gym after win, and Blackout
		return true
	end
	return false	
end

function EarthBadgeQuest:CeruleanCityBikeShop()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(6, 15)
end

function EarthBadgeQuest:CeruleanCity()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(15, 50)
end

function EarthBadgeQuest:Route5()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(21, 36)
end

function EarthBadgeQuest:Route5StopHouse()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(3, 12)
end

function EarthBadgeQuest:SaffronCity()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(26, 52)
end

function EarthBadgeQuest:Route6StopHouse()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(3, 12)
end

function EarthBadgeQuest:Route6()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(22, 61)
end

function EarthBadgeQuest:VermilionCity()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(82, 42)
end

function EarthBadgeQuest:Route11()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(10, 12)
end

function EarthBadgeQuest:DiglettsCaveEntrance2()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(20, 14)
end

function EarthBadgeQuest:DiglettsCave()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(27, 16)
end

function EarthBadgeQuest:DiglettsCaveEntrance1()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(15, 28)
end

function EarthBadgeQuest:Route2()
	sys.debug("quest", "Going to fight Giovanni.")
	if game.inRectangle(0, 0, 45, 94) then
		return moveToCell(39, 90)
	else
		return moveToCell(10, 130)
	end
end

function EarthBadgeQuest:Route2Stop3()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(3, 12)
end

function EarthBadgeQuest:ViridianCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Viridian" then
		sys.debug("quest", "Going to heal Pokemon.")
		return moveToCell(44, 43)

	elseif self:needPokemart() then
		sys.debug("quest", "Going to buy Pokeballs.")
		return moveToCell(54, 34)

	elseif hasItem("Earth Badge") then
		sys.debug("quest", "Going to E4.")
		return moveToCell(0, 48)

	elseif not self:isTrainingOver() then
		sys.todo("go and evolve pokemon instead of fataling")
		return fatal("Error This team can't beat Giovanni")

	else
		sys.debug("quest", "Going to fight Giovanni.")
		return moveToCell(60, 22) --Viridian Gym 2

	end
end

function EarthBadgeQuest:PokecenterViridian()
	if getTeamSize() ~= 6 then
		if isPCOpen() then
			if isCurrentPCBoxRefreshed() then
				log("Putting " .. getPokemonNameFromPC(getCurrentPCBoxId(), 1) .. " into our team.")
				withdrawPokemonFromPC(getCurrentPCBoxId(), 1)
			end
		else
			sys.debug("Putting a 6th Pokemon in our team.")
			return usePC()
		end
	elseif not self.checkedForBestPokemon then
		if isPCOpen() then
			if isCurrentPCBoxRefreshed() then
				if getCurrentPCBoxSize() ~= 0 then
					log("Current Box: " .. getCurrentPCBoxId())
					log("Box Size: " .. getCurrentPCBoxSize())
					for teamPokemonIndex = 1, getTeamSize() do
						if luaPokemonData[getPokemonName(teamPokemonIndex)]["TotalStats"] < luaPokemonData[getPokemonNameFromPC(getCurrentPCBoxId(), pc.getBestPokemonIdFromCurrentBox())]["TotalStats"] then
							log(string.format("Swapping Team Pokemon %s (Total Stats: %i) with Box %i Pokemon %s (Total Stats: %i)", getPokemonName(teamPokemonIndex), luaPokemonData[getPokemonName(teamPokemonIndex)]["TotalStats"], getCurrentPCBoxId(), getPokemonNameFromPC(getCurrentPCBoxId(), pc.getBestPokemonIdFromCurrentBox()), luaPokemonData[getPokemonNameFromPC(getCurrentPCBoxId(), pc.getBestPokemonIdFromCurrentBox())]["TotalStats"]))
							return swapPokemonFromPC(getCurrentPCBoxId(), pc.getBestPokemonIdFromCurrentBox(), teamPokemonIndex)
						end
					end
					return openPCBox(getCurrentPCBoxId() + 1)
				else
					sys.debug("quest", "Checked for best Pokemon from PC.")
					self.checkedForBestPokemon = true
				end
			end
		else
			sys.debug("quest", "Going to check for better Pokemon in boxes.")
			return usePC()
		end
	else
		self:pokecenter("Viridian City")
	end
end

function EarthBadgeQuest:ViridianPokemart()
	self:pokemart("Viridian City")
end

function EarthBadgeQuest:PlayerBedroomPallet() -- fix for tp after Kanto E4
	sys.debug("quest", "Going to Johto.")
	return moveToCell(12, 4)
end

function EarthBadgeQuest:PlayerHousePallet() -- fix for tp after Kanto E4
	sys.debug("quest", "Going to Johto.")
	return moveToCell(4, 10)
end

function EarthBadgeQuest:PalletTown()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(14, 0)
end

function EarthBadgeQuest:Route1()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(13, 4)
end

function EarthBadgeQuest:Route1StopHouse()
	sys.debug("quest", "Going to fight Giovanni.")
	return moveToCell(3, 2)
end

function EarthBadgeQuest:ViridianGym2()
	if hasItem("Earth Badge") then
		sys.debug("quest", "Going to E4.")
		return moveToCell(10, 32)
	else
		if isNpcOnCell(10,26) then --NPC Gary
			sys.debug("quest", "Going to talk to Gary.")
			return talkToNpcOnCell(10,26)
		else
			sys.debug("quest", "Going to fight Giovanni.")
			return talkToNpcOnCell(10,8)
		end
	end
end

return EarthBadgeQuest