TriggerServerEvent("loginresource:getFirstLoginData")

RegisterNetEvent("loginresource:sendFirstLoginData")
AddEventHandler("loginresource:sendFirstLoginData", function (isFirstLogin)
    Citizen.CreateThread(function ()
        if isFirstLogin == 1 then
        Citizen.Wait(2000) 
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
end)


RegisterNUICallback('character_creation', function(data, cb)
    local characterName = data.name
    TriggerServerEvent("loginresource:charNameCreated", characterName)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'ui',
        status = false
    })
    exports.characterhandler:StartCharacterCreator()
end)

RegisterCommand('custom', function()
    exports.characterhandler:StartCharacterCreator()
end, false)

RegisterCommand('loadchar', function()
    exports.characterhandler:LoadPlayerCharacter()
end, false)