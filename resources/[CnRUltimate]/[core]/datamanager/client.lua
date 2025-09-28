local PlayerCache = nil

RegisterNetEvent("datamanager:updateClientPlayerData")
AddEventHandler("datamanager:updateClientPlayerData", function (pData)
    PlayerCache = pData
end)

local function GetPlayerData()
    return PlayerCache
end
exports("GetPlayerData", GetPlayerData)
