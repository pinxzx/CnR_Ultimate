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

    local appearance = MySQL.query.await("SELECT appearance FROM character_appearance WHERE player_id = ?", {playerId})[1]
    TriggerClientEvent("characterhandler:sendCharacterLoad", src, appearance)
end)

RegisterNetEvent("characterhandler:server:requestLoadCopCharacter", function ()
    local src = source
    local playerId = exports.datamanager:GetPlayerId(src)
    local normal_appearance = MySQL.query.await("SELECT appearance FROM character_appearance WHERE player_id = ?", {playerId})[1]
    local cop_appearance = MySQL.query.await("SELECT appearance FROM police_character WHERE player_id = ?", {playerId})[1]

    TriggerClientEvent("characterhandler:sendCharacterLoad", src, normal_appearance, cop_appearance)
end)