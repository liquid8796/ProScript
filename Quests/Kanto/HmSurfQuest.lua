

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name		  = 'HM Surf'
local description = 'Kanto Safari'

local HmSurfQuest = Quest:new()

function HmSurfQuest:new()
	local o = Quest.new(HmSurfQuest, name, description, level)
	o.pokemon = "Exeggcute"
	o.forceCaught = false
	return o
end

function HmSurfQuest:isDoable()
	return self:hasMap()	
end

function HmSurfQuest:isDone()
	if (hasItem("HM03 - Surf") and getMapName() == "Safari Stop") or getMapName() == "Pokecenter Fuchsia" then --Fix Blackout
		return true		
	end
	return false
end

function HmSurfQuest:SafariEntrance()
	if not hasItem("HM03 - Surf") then
		sys.debug("quest", "Going to get HM03 - Surf.")
		return moveToCell(55, 12)
	else
		sys.debug("quest", "Going back to Fuchsia City.")
		return talkToNpcOnCell(27, 25)
	end
end

function HmSurfQuest:SafariArea1()
	if not self.forceCaught then
		sys.debug("quest", "Going to catch Exeggcute for later quest.")
		return moveToGrass()
	elseif not hasItem("HM03 - Surf") then
		sys.debug("quest", "Going to get HM03 - Surf.")
		return moveToCell(0, 17)
	else
		sys.debug("quest", "Going back to Fuchsia City.")
		return moveToCell(0, 34)
	end
end

function HmSurfQuest:SafariArea2()
	if not hasItem("HM03 - Surf") then
		sys.debug("quest", "Going to get HM03 - Surf.")
		return moveToCell(15, 44)
	else
		sys.debug("quest", "Going back to Fuchsia City.")
		return moveToCell(43, 36)
	end
end

function HmSurfQuest:SafariArea3()
	if not hasItem("HM03 - Surf") then
		sys.debug("quest", "Going to get HM03 - Surf.")
		return moveToCell(15, 17)
	else
		sys.debug("quest", "Going back to Fuchsia City.")
		return moveToCell(35, 0)
	end
end

function HmSurfQuest:SafariHouse4()
	sys.debug("quest", "Going back to Fuchsia City.")
	return moveToCell(10, 10)
end

return HmSurfQuest