local sys           = require "Libs/syslib"
local game          = require "Libs/gamelib"
local pc            = require "Libs/pclib"
local team          = require "Libs/teamlib"

local luaPokemonData = require "Data/luaPokemonData"

local Quest         = require "Quests/Quest"
local Dialog        = require "Quests/Dialog"

local name		    = 'Soul Badge'
local description   = 'Fuchsia City'
local level         = 56

local dialogs = {
	questSurfAccept = Dialog:new({ 
		"There is something there I want you to take",
		"Did you get the HM broseph"
	})
}

local SoulBadgeQuest = Quest:new()

function SoulBadgeQuest:new()
	local o = Quest.new(SoulBadgeQuest, name, description, level, dialogs)
	o.checkedForBestPokemon = false
	o.pokemonId = 1
	return o
end

function SoulBadgeQuest:isDoable()
	if not hasItem("Marsh Badge") and self:hasMap() then
		if getMapName() == "Route 15" then
			if hasItem("Soul Badge") and hasItem("HM03 - Surf") then
				return false
			else
				return true
			end
		else
			return true
		end
	end
	return false
end

function SoulBadgeQuest:isDone()
	if (hasItem("Soul Badge") and hasItem("HM03 - Surf") and getMapName() == "Route 15") or getMapName() == "Safari Entrance" or getMapName() == "Route 20"then
		return true
	else
		return false
	end
end

function SoulBadgeQuest:canEnterSafari()
	return getMoney() > 5000
end

function SoulBadgeQuest:FuchsiaCity()

	-- this will be true after ExpForSaffron quest
	if team.getLowestLvl() >= 60 then 
		sys.debug("quest", "Preparing to go to Saffron City.")
		return moveToCell(67, 26)

	-- heal team
	elseif self:needPokecenter() or	not game.isTeamFullyHealed() or	self.registeredPokecenter ~= "Pokecenter Fuchsia" then
		sys.debug("quest", "Going to heal Pokemon.")
		return moveToCell(30, 39)

	-- item: PP UP
	elseif isNpcOnCell(13, 7) then
		sys.debug("quest", "Pickung up hidden item PP UP.")
		return talkToNpcOnCell(13, 7)

	-- train team
	elseif not self:isTrainingOver() then
		if self:needPokemart() then
			sys.debug("quest", "Going to buy Pokeballs.")
			return moveToCell(15, 18)
		else
			sys.debug("quest", "Going to level Pokemon until Level " .. self.level .. ".")
			return moveToCell(67, 26)
		end

	-- gym fight
	elseif not hasItem("Soul Badge") then
        sys.debug("quest", "Going to fight the gym for 5th badge.")
		return moveToCell(13, 38)

	-- farm money for safari
	elseif not self:canEnterSafari() and not hasItem("HM03 - Surf") then
        sys.debug("quest", "Farming $" .. 5000 - getMoney() .. " more money, so we can enter the safari.")
		return moveToCell(67, 26)

	-- safari
	elseif not hasItem("HM03 - Surf") then
		if not dialogs.questSurfAccept.state then
            sys.debug("quest", "Going to fight Viktor, so we can enter Safari Zone.")
			return moveToCell(22, 44)
		else
            sys.debug("quest", "Going to Safari Zone to get HM03 - Surf.")
			return moveToCell(36, 5)
		end
	else
        sys.debug("quest", "Going to Route 19.")
		return moveToCell(22, 44)
	end
end

function SoulBadgeQuest:PokecenterFuchsia()
	if not hasPokemonInTeam("Flareon") then
		if hasPokemonInTeam("Eevee") then
			return useItemOnPokemon("Fire Stone", game.hasPokemonWithName("Eevee"))
		else
			if isPCOpen() then
				if isCurrentPCBoxRefreshed() then
					if getCurrentPCBoxSize() ~= 0 then
						log("Current Box: " .. getCurrentPCBoxId())
						log("Box Size: " .. getCurrentPCBoxSize())
						for i = 1, getCurrentPCBoxSize() do
							if isCurrentPCBoxRefreshed() then
								if getPokemonNameFromPC(getCurrentPCBoxId(), i) == "Eevee" or getPokemonNameFromPC(getCurrentPCBoxId(), i) == "Flareon" then
									if swapPokemonFromPC(getCurrentPCBoxId(), i, math.random(1, 6)) then
										log("Putting Eevee/Flareon in our team, so we can evolve it to Flareon.")
									end
								end
							end
						end
						if isCurrentPCBoxRefreshed() then
							return openPCBox(getCurrentPCBoxId() + 1)
						end
					else
						sys.debug("quest, Checked for Eevee/Flareon from PC.")
						return moveToCell(getPlayerX(), getPlayerY() + 1) -- close pc
					end
				end
			else
				sys.debug("quest", "Going to get Eevee/Flareon from Boxes.")
				return usePC()
			end
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
		self:pokecenter("Fuchsia City")
	end
end

function SoulBadgeQuest:FuchsiaPokemart()
	self:pokemart("Fuchsia City")
end

function SoulBadgeQuest:Route15StopHouse()

	if team.getLowestLvl() >= 60 then -- this will be true after ExpForSaffron quest
		sys.debug("quest", "Preparing to go to Saffron City.")
		return moveToCell(10, 7)
	
	if self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Fuchsia" then
		sys.debug("quest", "Going to heal Pokemon.")
		return moveToCell(0, 6)

	elseif not self:isTrainingOver() then
		sys.debug("quest", "Going to level Pokemon until Level " .. self.level .. ".")
		return moveToCell(10, 6)

	elseif not self:canEnterSafari() then
		sys.debug("quest", "Farming $" .. 5000 - getMoney() .. " more money, so we can enter the safari.")
		return moveToCell(10, 6)

	elseif hasItem("HM03 - Surf") then
		sys.debug("quest", " ???? ")
		-- return moveToCell(10, 6)

	else
		sys.debug("quest", "Going back to Fuchsia City.")
		return moveToCell(0, 6)
	end
end

function SoulBadgeQuest:Route15()
	if self:needPokecenter() or self.registeredPokecenter ~= "Pokecenter Fuchsia" then
		sys.debug("quest", "Going to heal Pokemon.")
		return moveToCell(6, 16)

	elseif not self:isTrainingOver() then
		sys.debug("quest", "Going to level Pokemon until Level " .. self.level .. ".")
		--return moveToRectangle(50, 19, 56, 22)
		return moveToGrass()

	elseif not self:canEnterSafari() and not hasItem("HM03 - Surf") then
		sys.debug("quest", "Farming $" .. 5000 - getMoney() .. " more money, so we can enter the safari.")
		return moveToRectangle(50, 19, 56, 22)

	elseif self:canEnterSafari() then
		sys.debug("quest", "Earned enough money for Safari.")
		return moveToCell(6, 16)
	
	else
		sys.debug("quest", "Going back to Fuchsia City.")
		return moveToCell(6, 16)
	end
end

function SoulBadgeQuest:SafariStop()
	if hasItem("Soul Badge") and dialogs.questSurfAccept.state then
		if not hasItem("HM03 - Surf") and self:canEnterSafari() then
			sys.debug("quest", "Going to Safari Zone to get HM03 - Surf.")
			return talkToNpcOnCell(7, 3)
		else
			sys.debug("quest", "Going back to Fuchsia City.")
			return moveToCell(7, 15)
		end
	else
		sys.debug("quest", "Going back to Fuchsia City.")
		return moveToCell(7, 15)
	end
end



function SoulBadgeQuest:FuchsiaCityStopHouse()
	if team.getLowestLvl() >= 60 then -- this will be true after ExpForSaffron quest
		sys.debug("quest", "Preparing to go to Saffron City.")
		return moveToCell(7, 3)
	elseif not hasItem("HM03 - Surf") then
		if dialogs.questSurfAccept.state then
			sys.debug("quest", "Going to Safari Zone to get HM03 - Surf.")
			return moveToCell(6, 3)
		else
			sys.debug("quest", "Going to talk to Viktor.")
			return moveToCell(6, 20)
		end
	else
		sys.debug("quest", "Going to level Pokemon in Seafoam.")
		return moveToCell(6, 20)
	end
end

function SoulBadgeQuest:Route19()
	if team.getLowestLvl() >= 60 then -- this will be true after ExpForSaffron quest
		sys.debug("quest", "Preparing to go to Saffron City.")
		return moveToCell(23, 3)
	elseif hasItem("HM03 - Surf") then
		if not game.hasPokemonWithMove("Surf") then
			if self.pokemonId <= getTeamSize() then
				useItemOnPokemon("HM03 - Surf", self.pokemonId)
				log("Pokemon: " .. self.pokemonId .. " Try Learning: HM03 - Surf")
				self.pokemonId = self.pokemonId + 1
				return
			else
				fatal("No pokemon in this team can learn - Surf")
			end
		else
			sys.debug("quest", "Going to Route 20.")
			return moveToCell(0,41)
		end
	else
		if dialogs.questSurfAccept.state then	
			sys.debug("quest", "Going to Safari Zone to get HM03 - Surf.")
			return moveToCell(22,3)
		else
			sys.debug("quest", "Going to talk to Viktor.")
			return talkToNpcOnCell(33,19)
		end
	end
end



function SoulBadgeQuest:FuchsiaGym()
	if not hasItem("Soul Badge") then
		sys.debug("quest", "Going to fight Janine for 5th badge.")
		return talkToNpcOnCell(7, 10)
	else
		sys.debug("quest", "Going back to Fuchsia City.")
		return moveToCell(6, 16)
	end
end

return SoulBadgeQuest