-- Copyright © 2016 Rympex <Rympex@noemail>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local Quest  = require "Quests/Quest"

local name        = 'Lance Vermilion Quest'
local description = 'Lance vision'

local LanceVermilionQuest = Quest:new()

function LanceVermilionQuest:new()
	return Quest.new(LanceVermilionQuest, name, description, level)
end

function LanceVermilionQuest:isDoable()
	return self:hasMap()
end

function LanceVermilionQuest:isDone()
	return getMapName() == "Pokecenter Vermilion"
end

function LanceVermilionQuest:VermilionCity2()
	sys.debug("quest", "Going to talk to NPC.")
	return talkToNpcOnCell(44, 30)
end

return LanceVermilionQuest