TriggerServerEvent("loginresource:getFirstLoginData")

RegisterNetEvent("loginresource:sendFirstLoginData")
AddEventHandler("loginresource:sendFirstLoginData", function (isFirstLogin)
    if isFirstLogin == 1 then
        Wait(2000) 
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = 'ui',
            status = true
        })
    else
        exports.spawnresource:spawnPlayer()
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = 'ui',
            status = false
        })
    end
end)


RegisterNUICallback('character_creation', function(data, cb)
    local characterName = data.name
    TriggerServerEvent("loginresource:charNameCreated", characterName)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'ui',
        status = false
    })
    exports.charactercreation:StartCharacterCreation()
end)