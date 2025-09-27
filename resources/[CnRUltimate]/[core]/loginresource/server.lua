RegisterNetEvent("loginresource:getFirstLoginData")
AddEventHandler("loginresource:getFirstLoginData", function ()
    local src = source
    local playerId = exports.datamanager:GetPlayerId(src)
    local firstLogin = MySQL.query.await("SELECT firstLogin FROM players WHERE id = ?", {playerId})[1]
    TriggerClientEvent("loginresource:sendFirstLoginData", src, firstLogin.firstLogin)
end)

RegisterNetEvent("loginresource:charNameCreated")
AddEventHandler("loginresource:charNameCreated", function(name)
    local src = source
    local playerId = exports.datamanager:GetPlayerId(src)
    exports.datamanager:SetPlayerName(playerId, name)
    MySQL.update.await("UPDATE players SET firstLogin = ? WHERE id = ?", {"0", playerId})
end)