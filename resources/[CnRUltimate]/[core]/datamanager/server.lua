PlayersCache = {}

local function GetPlayerId(src)
    local identifier = GetPlayerIdentifiers(src)[1]
    local playerId = MySQL.query.await("SELECT id FROM players WHERE identifier = ?", { identifier })
    return playerId[1].id
end
exports("GetPlayerId", GetPlayerId)

-- Check if the player is banned. Return a banned info table.
local function checkBan(playerId)
    local data_ban = MySQL.query.await('SELECT * FROM banned_players WHERE player_id = ?', { playerId })[1]

    if data_ban == nil then return nil end

    return data_ban
end

local function SavePlayerData(pId)
    local pData = PlayersCache[pId]

    if not pData then
        print("Player Cahce not Found!")
        return
    end

    MySQL.update.await("UPDATE players SET cash = ?, bank = ?, job = ?, job_grade = ?, jail_time = ? WHERE id = ?", {
        pData.cash,
        pData.bank,
        pData.job,
        pData.job_grade,
        pData.jail_time,
        pData.id
    })
end

local function SaveAllPlayersData()
    for pId, _ in pairs(PlayersCache) do
        SavePlayerData(pId)
    end
end

-- Return all the player data with the defined Player ID.
local function GetPlayerData(src)
    local playerId = GetPlayerId(src)
    local pData = PlayersCache[playerId]

    return pData
end
exports("GetPlayerData", GetPlayerData)


-- Set the player name to a the player with the pId. Return nil if player doesnt exists in PlayerCache.
local function SetPlayerName(pId, name)
    if not PlayersCache[pId] then return nil end
    PlayersCache[pId].name = name
    MySQL.update.await("UPDATE players SET name = ? WHERE id = ?", { PlayersCache[pId].name, pId })
end
exports("SetPlayerName", SetPlayerName)

-- Gets the player name with the pId. Return nil if player doesnt exists in PlayerCache.
local function GetPlayerName(pId)
    if not PlayersCache[pId] then return nil end
    return PlayersCache[pId].name
end
exports("GetPlayerName", GetPlayerName)

local function GetPlayerJob(pId)
    if not PlayersCache[pId] then return nil end
    return PlayersCache[pId].job
end


-- SaveData
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        SaveAllPlayersData()
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        for pId, pData in pairs(PlayersCache) do
            local targetSrc = nil
            for _, src in pairs(GetPlayers()) do
                local identifier = GetPlayerIdentifiers(src)[1]
                if identifier == pData.identifier then
                    targetSrc = src
                    break
                end
            end
            if targetSrc then TriggerClientEvent("datamanager:updateClientPlayerData", targetSrc, pData) end
        end
    end
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
    local src = source
    Citizen.CreateThread(function()
        local identifier = GetPlayerIdentifiers(src)[1]
        deferrals.defer()
        deferrals.update("Hello " .. name .. "!" .. " We are checking your data!")

        local data = MySQL.query.await('SELECT * FROM players WHERE identifier = ?', { identifier })
        local pData = data[1]

        Citizen.Wait(0) -- Obrigatorio

        if not pData then
            deferrals.update("Are you a new player? Welcome! Checking connection...")
            MySQL.insert.await('INSERT INTO `players` (identifier) VALUES (?)', { identifier })
            Wait(2000)
            pData = MySQL.query.await('SELECT * FROM players WHERE identifier = ?', { identifier })[1]
        else
            deferrals.update("✅ - Data loaded successefully!...")
            Wait(2000)
        end

        local ban_data = checkBan(pData.id)
        if not ban_data then
            deferrals.update("✅ - Ban not found!")
            Wait(1000)
            deferrals.done()
        else
            deferrals.done("🚫 - You are banned. Reason: " ..
            ban_data.reason ..
            ". If you think the ban was unfair, you can request a ban appeal with this reference: ref#" .. ban_data.id)
        end

        -- Save cache
        PlayersCache[pData.id] = pData
    end)
end)

AddEventHandler("playerDropped", function(reason, resourceName, clientDropReason)
    local src = source
    local identifier = GetPlayerIdentifiers(src)[1]
    local pData = nil

    for id, data in pairs(PlayersCache) do
        if identifier == data.identifier then
            pData = data
            break
        end
    end

    if pData then
        SavePlayerData(pData.id)
        PlayersCache[pData.id] = nil
    end
end)

RegisterNetEvent("datamanager:getPlayerJob")
AddEventHandler("datamanager:getPlayerJob", GetPlayerJob)
