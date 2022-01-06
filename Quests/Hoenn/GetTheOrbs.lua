-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @WiWi__33[NetPapa]


local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local pc	 = require "Libs/pclib"
local Quest  = require "Quests/Quest"

local luaPokemonData = require "Data/luaPokemonData"

local name		  = 'Get the Orbs'
local description = 'Will get the Blue and Red Orbs'
local level = 60

local GetTheOrbs = Quest:new()

function GetTheOrbs:new()
	local o = Quest.new(GetTheOrbs, name, description, level, dialogs)
	o.checkedForBestPokemon = false
	return o
end

function GetTheOrbs:isDoable()
	if self:hasMap() and not hasItem("Blue Orb") and not hasItem("Mind Badge") then
		return true
	end
	return false
end

function GetTheOrbs:isDone()
	if hasItem("Blue Orb") and getMapName() == "Mt. Pyre Summit" then
		return true
	else
		return false
	end
end

function GetTheOrbs:Route120()
	if self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Fortree City" then 
		sys.debug("quest", "Going to heal Pokemon.")
		return moveToCell(0, 8)
	elseif not self:isTrainingOver() then 
		sys.debug("quest", "Going to level Pokemon until Level " .. self.level .. ".")
		return moveToRectangle(36, 7, 44, 7)
	elseif not hasItem("Feather Badge") then
		sys.debug("quest", "Going to get 6th badge.")
		return moveToCell(0, 8)
	else
		sys.debug("quest", "Going to get the orbs.")
		return moveToCell(50, 100)
	end
end

function GetTheOrbs:FortreeCity()
	if self:needPokecenter() or not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Fortree City" then
		sys.debug("quest", "Going to heal Pokemon.")
		return moveToCell(8, 11)
	elseif self:needPokemart() then
		sys.debug("quest", "Going to buy Pokeballs.")
		return moveToCell(7, 23)
	elseif not self:isTrainingOver() then 
		sys.debug("quest", "Going to level Pokemon until Level " .. self.level .. ".")
		return moveToCell(54, 14)
	elseif not hasItem("Feather Badge") then 
		sys.debug("quest", "Going to get 6th badge.")
		return moveToCell(29, 16)
	else
		sys.debug("quest", "Going to get the orbs.")
		return moveToCell(54, 14)
	end
end

function GetTheOrbs:PokecenterFortreeCity()
	if not self.checkedForBestPokemon then
		if isPCOpen() then
			if isCurrentPCBoxRefreshed() then
				if getCurrentPCBoxSize() ~= 0 then
					log("Current Box: " .. getCurrentPCBoxId())
					log("Box Size: " .. getCurrentPCBoxSize())
					for teamPokemonIndex = 1, getTeamSize() do
						if pc.getBestPokemonIdFromCurrentBoxFromRegion("Hoenn") ~= nil then
							if luaPokemonData[getPokemonName(teamPokemonIndex)]["TotalStats"] < luaPokemonData[getPokemonNameFromPC(getCurrentPCBoxId(), pc.getBestPokemonIdFromCurrentBoxFromRegion("Hoenn"))]["TotalStats"] then
								log(string.format("Swapping Team Pokemon %s (Total Stats: %i) with Box %i Pokemon %s (Total Stats: %i)", getPokemonName(teamPokemonIndex), luaPokemonData[getPokemonName(teamPokemonIndex)]["TotalStats"], getCurrentPCBoxId(), getPokemonNameFromPC(getCurrentPCBoxId(), pc.getBestPokemonIdFromCurrentBoxFromRegion("Hoenn")), luaPokemonData[getPokemonNameFromPC(getCurrentPCBoxId(), pc.getBestPokemonIdFromCurrentBoxFromRegion("Hoenn"))]["TotalStats"]))
								return swapPokemonFromPC(getCurrentPCBoxId(), pc.getBestPokemonIdFromCurrentBoxFromRegion("Hoenn"), teamPokemonIndex)
							end
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
		return self:pokecenter("Fortree City")
	end
end

function GetTheOrbs:FortreeMart()
	return self:pokemart()
end

function GetTheOrbs:FortreeGym()
	if not hasItem("Feather Badge") then
		sys.debug("quest", "Going to get 6th badge.")
		return talkToNpcOnCell(19, 7)
	else
		sys.debug("quest", "Going to get the orbs.")
		return moveToCell(14, 65)
	end
end

function GetTheOrbs:Route121()
	sys.debug("quest", "Going to get the orbs.")
	return moveToCell(30, 35)
end

function GetTheOrbs:Route122()
	sys.debug("quest", "Going to get the orbs.")
	return moveToCell(60, 38)
end

function GetTheOrbs:MtPyre1F()
	sys.debug("quest", "Going to get the orbs.")
	return moveToCell(2, 4)
end

function GetTheOrbs:MtPyre2F()
	sys.debug("quest", "Going to get the orbs.")
	return moveToCell(26, 4)
end

function GetTheOrbs:MtPyre3F()
	if isNpcOnCell(13, 26) then
		sys.debug("quest", "Going to talk to NPC.")
		return talkToNpcOnCell(13, 26)
	else
		sys.debug("quest", "Going to get the orbs.")
		return moveToCell(13, 27)
	end
end

function GetTheOrbs:MtPyreExterior()
	sys.debug("quest", "Going to get the orbs.")
	return moveToCell(25, 0)
end

function GetTheOrbs:MtPyreSummit() -- need to check
	if isNpcOnCell(27, 12) then 
		sys.debug("quest", "Going to talk to NPC.")
		return talkToNpcOnCell(27, 12)
	elseif isNpcOnCell(27, 4) then
		sys.debug("quest", "Going to talk to NPC.")
		return moveToCell(27, 6)
	elseif isNpcOnCell(26, 4) then
		sys.debug("quest", "Going to talk to Old Man.")
		return talkToNpcOnCell(26, 4)
	end
end

return GetTheOrbs