local PlayerData = nil

exports.spawnmanager:setAutoSpawn(true)
TriggerServerEvent("spawnresource:requestPlayerData")

local spawnPoints = {
    civilians = {
        vector3(-1485.5, -1488.0, 2.6),
        vector3(215.8, -810.1, 30.7),
        vector3(-1037.6, -2737.8, 20.2)
    },
    cops = {
        vector3(-2043.6, 3130.0, 32.8),
        vector3(1728.0, 6414.1, 35.0),
        vector3(-447.1, 6012.8, 31.7)
    },
    medics = {
        vector3(501.9, 5604.9, 797.9),
        vector3(1203.6, -3115.9, 5.5),
        vector3(709.3, 1198.8, 326.3)
    }
}

local function spawnPlayer()

    local spawnPosition
    if not PlayerData then TriggerServerEvent("spawnresource:requestPlayerData") end
    while PlayerData == nil do Wait(0) end
    
    local playerJob = PlayerData.job

    if playerJob == "Civilian" then
        spawnPosition = spawnPoints.civilians[math.random(#spawnPoints.civilians)]
    elseif playerJob == "Cop" then
        spawnPosition = spawnPoints.cops[math.random(#spawnPoints.cops)]
    elseif playerJob == "Medic" then
        spawnPosition = spawnPoints.medics[math.random(#spawnPoints.medics)]
    end
    DoScreenFadeOut(500)
    exports.spawnmanager:spawnPlayer({
        x = spawnPosition.x,
        y = spawnPosition.y,
        z = spawnPosition.z,
        heading = 0,
        skipFade = true
    }, function ()
        exports.characterhandler:LoadPlayerCharacter()
        Wait(3000)
        DoScreenFadeIn(500)
    end)
    TriggerEvent("spawnresource:playerSpawnedClient")
end
exports("spawnPlayer", spawnPlayer)



RegisterNetEvent("spawnresource:spawnPlayer")
AddEventHandler("spawnresource:spawnPlayer", spawnPlayer)

RegisterNetEvent("spawnresource:sendPlayerData")
AddEventHandler("spawnresource:sendPlayerData", function (pData)
    PlayerData = pData
end)
local model = RequestModel(`mp_m_freemode_01`)
    -- while not HasModelLoaded(`mp_m_freemode_01`) do Wait(0) RequestModel(`mp_m_freemode_01`) end
    -- SetPlayerModel(PlayerId(), `mp_m_freemode_01`)
    -- SetModelAsNoLongerNeeded(`mp_m_freemode_01`)

    -- RequestCollisionAtCoord(spawnPosition.x, spawnPosition.y, spawnPosition.z)

    -- local ped = PlayerPedId()
    -- SetEntityCoordsNoOffset(ped, spawnPosition.x, spawnPosition.y, spawnPosition.z, false, false, false, true)