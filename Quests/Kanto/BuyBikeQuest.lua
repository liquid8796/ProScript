-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.
-- Quest: @Rympex


local sys    = require "Libs/syslib"
local pc	 = require "Libs/pclib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'Buy Bike'
local description = 'Go to Cerulean City, get Ditto from Boxes, exchange it for Bike Voucher, get Bike.'

local BuyBikeQuest = Quest:new()

local dialogs = {
	foundDitto = Dialog:new({
		"Let me check that Ditto for your OT",
	}),
	talkToMeAgain = Dialog:new({
		"talk to me again!",
	}),
}

function BuyBikeQuest:new()
	local o = Quest.new(BuyBikeQuest, name, description, level, dialogs)
	o.needCutPokemon = false
	return o
end

function BuyBikeQuest:isDoable()
	if self:hasMap() and hasItem("Volcano Badge") and not hasItem("Earth Badge") and not hasItem("Bicycle") then
		return true
	end
	return false
end

function BuyBikeQuest:isDone()
	if hasItem("Bicycle") or getMapName() == "Pokecenter Cinnabar" then
		return true
	end
	return false
end

function BuyBikeQuest:Route21()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(14, 0)
end

function BuyBikeQuest:PalletTown()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(14, 0)
end

function BuyBikeQuest:Route1()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(14, 4)
end

function BuyBikeQuest:Route1StopHouse()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(4, 2)
end

function BuyBikeQuest:ViridianCity()
	if self.needCutPokemon then
		sys.debug("quest", "Going to get Pokemon with Cut from Boxes.")
		return moveToCell(44, 43)
	if not game.hasPokemonWithMove("Cut") then
		self.needCutPokemon = true
	else
		sys.debug("quest", "Going to get Bike.")
		return moveToCell(39, 0)
	end
end

function BuyBikeQuest:PokecenterViridian()
	if self.needCutPokemon then
		if isPCOpen() then
			if isCurrentPCBoxRefreshed() then
				if getCurrentPCBoxSize() ~= 0 then
					log("Current Box: " .. getCurrentPCBoxId())
					log("Box Size: " .. getCurrentPCBoxSize())
					for i = 1, getCurrentPCBoxSize() do
						for moveId = 1, 4 do
							if isCurrentPCBoxRefreshed() then
								if getPokemonMoveNameFromPC(getCurrentPCBoxId(), i, moveId) == "Cut" then
									if swapPokemonFromPC(getCurrentPCBoxId(), i, 1) then
										self.needCutPokemon = false
										log("Swapping first Pokemon in Team for Pokemon with Cut, will get it back later again.")
									end
								end
							end
						end
					end
					return openPCBox(getCurrentPCBoxId() + 1)
				else
					sys.debug("quest", "Checked for Cut Pokemon from PC.")
				end
			end
		else
			sys.debug("quest", "Going to get Pokemon with Cut from Boxes.")
			return usePC()
		end
	else
		self:pokecenter("Viridian City")
	end
end

function BuyBikeQuest:Route2()
	sys.debug("quest", "Going to get Bike.")
	if game.inRectangle(0, 93, 45, 130) then
		return moveToCell(39, 96)
	else
		return moveToCell(33, 31)
	end
end

function BuyBikeQuest:Route2Stop3()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(3, 2)
end

function BuyBikeQuest:DiglettsCaveEntrance1()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(24, 19)
end

function BuyBikeQuest:DiglettsCave()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(52, 56)
end

function BuyBikeQuest:DiglettsCaveEntrance2()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(20, 28)
end

function BuyBikeQuest:Route11()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(0, 14)
end

function BuyBikeQuest:VermilionCity()
	if not hasItem("Bike Voucher") then
		if hasPokemonInTeam("Ditto") then
			sys.debug("quest", "Going to get Bike Voucher for giving away Ditto.")
			return moveToCell(32, 21)
		else
			sys.debug("quest", "Going to get Ditto from Boxes.")
			return moveToCell(27, 21)
		end
	else
		sys.debug("quest", "Going to get Bike.")
		return moveToCell(42, 0)
	end
end

function BuyBikeQuest:PokecenterVermilion()
	if not hasPokemonInTeam("Ditto") then
		if isPCOpen() then
			if isCurrentPCBoxRefreshed() then
				if getCurrentPCBoxSize() ~= 0 then
					log("Current Box: " .. getCurrentPCBoxId())
					log("Box Size: " .. getCurrentPCBoxSize())
					for i = 1, getCurrentPCBoxSize() do
						if isCurrentPCBoxRefreshed() then
							if getPokemonNameFromPC(getCurrentPCBoxId(), i) == "Ditto" then
								if swapPokemonFromPC(getCurrentPCBoxId(), i, 2) then
									log("Swapping 2nd Pokemon in Team for Ditto, will get it back later again.")
								end
							end
						end
					end
					if isCurrentPCBoxRefreshed() then
						return openPCBox(getCurrentPCBoxId() + 1)
					end
				else
					sys.debug("quest", "Checked for Ditto from PC.")
				end
			end
		else
			sys.debug("quest", "Going to get Ditto from Boxes.")
			return usePC()
		end
	else
		self:pokecenter("Vermilion City")
	end
end

function BuyBikeQuest:VermilionHouse2Bottom()
	if hasItem("Bike Voucher") then
		sys.debug("quest", "Going to get Bike.")
		return moveToCell(5, 10)
	else
		if dialogs.talkToMeAgain.state then
			return talkToNpcOnCell(6, 6)
		elseif hasPokemonInTeam("Ditto") then
			if dialogs.foundDitto.state then
				sys.debug("quest", "Going to get Bike Voucher for giving away Ditto.")
				pushDialogAnswer(game.hasPokemonWithName("Ditto"))
				return talkToNpcOnCell(6, 6)
			else
				sys.debug("quest", "Going to get Bike Voucher for giving away Ditto.")
				return talkToNpcOnCell(6, 6)
			end
		else
			return talkToNpcOnCell(6, 6)
		end
	end
end

function BuyBikeQuest:Route6()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(26, 5)
end

function BuyBikeQuest:Route6StopHouse()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(3, 2)
end

function BuyBikeQuest:SaffronCity()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(26, 5)
end

function BuyBikeQuest:Route5StopHouse()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(3, 2)
end

function BuyBikeQuest:Route5()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(27, 0)
end

function BuyBikeQuest:CeruleanCity()
	sys.debug("quest", "Going to get Bike.")
	return moveToCell(15, 38)
end

function BuyBikeQuest:CeruleanCityBikeShop()
	sys.debug("quest", "Going to get Bike.")
	return talkToNpcOnCell(11, 7)
end

return BuyBikeQuest