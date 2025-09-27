RegisterNetEvent("characterhandler:SavePlayerCharacter")
AddEventHandler("characterhandler:SavePlayerCharacter", function(appearance)
    local src = source
    local playerId = exports.datamanager:GetPlayerId(src)

    MySQL.update.await("UPDATE character_appearance SET appearance = ? WHERE player_id = ?", {json.encode(appearance), playerId})
end)

RegisterNetEvent("characterhandler:requestLoadCharacter")
AddEventHandler("characterhandler:requestLoadCharacter", function ()
    local src = source
    local playerId = exports.datamanager:GetPlayerId(src)

    local appearance = MySQL.query.await("SELECT appearance FROM character_appearance WHERE player_id = ?", {playerId})
    TriggerClientEvent("characterhandler:sendCharacterLoad", src, appearance)
end)