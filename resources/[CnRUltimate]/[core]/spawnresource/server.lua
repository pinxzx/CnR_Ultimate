RegisterNetEvent("spawnresource:requestPlayerData")
AddEventHandler("spawnresource:requestPlayerData", function()
    local src = source
    
    local pData = exports.datamanager:GetPlayerData(src)
    TriggerClientEvent("spawnresource:sendPlayerData", src, pData)
end)