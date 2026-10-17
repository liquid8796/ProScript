name = "Leveling: Route 10 (Rock Tunnel, LinkGraph v2)"
author = "Liquid"
version = "1.0.373"
description = [[Train and hunt between the two Route 10 entrances through Rock Tunnel.
Uses the confirmed LinkGraph v2 warp coordinates and sector-aware navigation.
Can start at either Route 10 entrance, in Rock Tunnel, or at the Pokecenter.]]

local team = require "../../Libs/teamlib"
local maxLv = 99
local maxUsablePokemon = 1

-- Server-confirmed LinkGraph v2 source cells, 2026-10-17.
-- Room labels such as "Rock Tunnel 1" are reused by disconnected sectors.
-- A map name alone is NOT enough to select the correct warp.
local warps = {
    ["Rock Tunnel 1"] = {
        east = { south = {35, 16}, north = {43, 11} },
        west = { south = {8, 15}, north = {7, 7} },
        south = { south = {21, 32}, north = {7, 30} },
    },
    ["Rock Tunnel 2"] = {
        upper = { south = {7, 5}, north = {36, 16} },
        lower = { south = {8, 26}, north = {10, 13} },
    },
}

-- Confirmed landing cells (destination of each v2 link), not guessed entrances.
local landings = {
    ["Rock Tunnel 1"] = {
        {43, 10, "east"}, {35, 16, "east"},
        {7, 7, "west"}, {8, 15, "west"},
        {21, 31, "south"}, {7, 30, "south"},
    },
    ["Rock Tunnel 2"] = {
        {36, 16, "upper"}, {7, 5, "upper"},
        {10, 13, "lower"}, {8, 26, "lower"},
    },
}

local lastMap, currentSector
local tourDirection = "south"

local function detectSector(map, x, y)
    -- Prefer observed landing coordinates immediately after a map transition.
    -- One or two steps of tolerance cover small server-side position adjustments.
    local nearest, distance = nil, math.huge
    for _, landing in ipairs(landings[map]) do
        local dx, dy = math.abs(x - landing[1]), math.abs(y - landing[2])
        local d = dx + dy
        if dx <= 2 and dy <= 2 and d < distance then
            nearest, distance = landing[3], d
        end
    end
    if nearest then return nearest end

    -- Resume/reload when already somewhere inside the cave, not on a landing.
    -- Use the legacy area geometry without the buggy isInArea OR expression.
    if map == "Rock Tunnel 1" then
        if x >= 30 then return "east" end
        if y >= 19 then return "south" end
        return "west"
    end
    if x >= 30 or y <= 11 then return "upper" end
    return "lower"
end

local function moveThroughTunnel(map, x, y, direction)
    if map ~= lastMap then
        lastMap = map
        currentSector = detectSector(map, x, y)
        log("Rock Tunnel: " .. map .. " (" .. x .. "," .. y .. ") => " .. currentSector)
    end
    local target = warps[map][currentSector][direction]
    return moveToCell(target[1], target[2])
end

function onStart()
    lastMap, currentSector = nil, nil
    tourDirection = "south"
    return team.onStart(maxLv)
end

function onPathAction()
    if team.setMountForTrainingMap() then return end
    if getOption(4) and not isTeamSortedByLevelAscending() then
        return sortTeamByLevelAscending()
    end
    if team.isTrainingOver(maxLv) and not team.isSearching() then
        return fatal("Complete training! Stop the bot.")
    end
    if team.useLeftovers() then return end

    local map = getMapName()
    if map == "Prof. Antibans Classroom" then
        return team.antibanclassroom()
    end

    local training = getUsablePokemonCount() > maxUsablePokemon
        and (getPokemonLevel(team.getLowestIndexOfUsablePokemon()) < maxLv
            or team.isSearching())

    if map == "Pokecenter Route 10" then
        if training then return moveToCell(9, 22) end
        return usePokecenter()
    end

    local x, y = getPlayerX(), getPlayerY()
    if map == "Route 10" then
        lastMap, currentSector = nil, nil
        if not training then
            -- Route 10 -> Pokecenter warp is at the northern (18,4) cell.
            if y > 43 then return moveToCell(5, 44) end
            return moveToCell(18, 4)
        end
        if y > 43 then
            -- South exit (5,45): reverse the traversal toward the north exit.
            tourDirection = "north"
            return moveToCell(5, 44)
        end
        -- North exit (11,6) or Pokecenter landing (18,5): head south.
        tourDirection = "south"
        return moveToCell(11, 5)
    end

    if warps[map] then
        -- Low-HP / PP recovery always heads for the northern Pokecenter.
        return moveThroughTunnel(map, x, y, training and tourDirection or "north")
    end
end

function onBattleAction()
    return team.onBattleFighting()
end

function onBattleMessage(message)
    return team.onBattleMessage(message)
end

function onDialogMessage(message)
    return team.onAntibanDialogMessage(message)
end

function onSystemMessage(message)
    return team.onSystemMessage(message)
end
