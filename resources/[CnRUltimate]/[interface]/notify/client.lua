-- client/main.lua

local function showNotification(text, type)
    SendNUIMessage({
        action = 'show',
        text = text,
        type = type or 'info'
    })
end

exports('Notify', function(text, type)
    showNotification(text, type)
end)

RegisterNetEvent('notify:show', function(text, type)
    showNotification(text, type)
end)