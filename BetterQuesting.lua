
name = "Questing"
author = "g0ld, rympex, wiwi33, m1l4, dubscheckum, atem"
description = [[MainQuesting until end of Hoenn region.]]

dofile "config.lua"

local QuestManager
local questManager = nil

local mountList = require "mountList"
local waterMountList = require "waterMountList"

local canBuyGreatballs = false
local canBuyUltraballs = false

local ran = 1
local isNeedMount = true

function onStart()
	setOptionName(1, "Relog on stop")
	
	if isNeedMount then
		for key, mount in ipairs(mountList) do
			if hasItem(mount) then
				setMount(mount)
				break
			end
		end
		
		for key, waterMount in ipairs(waterMountList) do
			if hasItem(waterMount) then
				setWaterMount(waterMount)
				break
			end
		end	
	end

	math.randomseed(os.time())
	QuestManager = require "Quests/QuestManager"
	log("all fine")
	questManager = QuestManager:new()

	--for longer botting runs
	if DISABLE_PM and isPrivateMessageEnabled() then
		log("Private messages disabled.")
		return disablePrivateMessage()
	end
end

function onPause()
	questManager:pause()
end

function onResume()
end

function onStop()
	if getOption(1) then
		return relog(60, "Relogging.")
	end
end

function onPathAction()
	if getMapName() == "Prof. Antibans Classroom" then
		if useItem("Escape Rope") then
			return
		end
		log("Quiz detected, talking to the prof.")
		pushDialogAnswer(1)
		talkToNpc("Prof. Antiban")
	end
	questManager:path()
	if questManager.isOver then
		return fatal("No more quests to do. Script terminated.")
	end
end

function onBattleAction()
	questManager:battle()
end

function onDialogMessage(message)
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
	questManager:dialog(message)
end

function onBattleMessage(message)
	questManager:battleMessage(message)
end

function onSystemMessage(message)
	questManager:systemMessage(message)
end

function onLearningMove(moveName, pokemonIndex)
	questManager:learningMove(moveName, pokemonIndex)
end


