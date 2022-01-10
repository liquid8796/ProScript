
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

function onStart()
	setOptionName(1, "Relog on stop")

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
	questManager:path()
	if questManager.isOver then
		return fatal("No more quests to do. Script terminated.")
	end
end

function onBattleAction()
	questManager:battle()
end

function onDialogMessage(message)
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

antibanQuestions = {

["What type is Flygon?"] = "Dragon/Ground",
["How many Pokemon can Eevee currently evolve into?"] = "8",
["Which of these are effective against Dragon?"] = "Dragon",
["What level does Litleo evolve into Pyroar?"] = "35",
["Articuno is one of the legendary birds of Kanto."] = "True",

}

function onAntibanPathAction()
	if getMapName() == "Prof. Antibans Classroom" then
		log("Quiz detected, talking to the prof.")
		talkToNpc("Prof. Antiban")
	end
end

function onAntibanDialogMessage(message)
	if getMapName() ~= "Prof. Antibans Classroom" then
		return
	end
	if stringContains(message, "incorrect") then
		fatal("Could not answer correctly, stopping the bot.")
	end
	for key, value in pairs(antibanQuestions) do
		if stringContains(message, key) then
			pushDialogAnswer(value)
		end
	end
end

registerHook("onPathAction", onAntibanPathAction)
registerHook("onDialogMessage", onAntibanDialogMessage)