local function SaveCharacter(playerId)

    -- Por fazer

end

RegisterNetEvent("lbg-chardone", function (char)
    local src = source
    local playerId = exports.datamanager:GetPlayerId(src)
    TriggerClientEvent("spawnresource:spawnPlayer", src)
    SaveCharacter(playerId)
end)
