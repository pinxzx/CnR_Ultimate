AddEventHandler('loadscreen:onprogress', function(data)
   
    SendNUIMessage({
        type = 'loadProgress',
        progress = data.progress, 
        loadText = data.loadtext  
    })
end)

CreateThread(function()
    while GetIsLoadingScreenActive() do
        Wait(200)
    end

    SendNUIMessage({ type = 'endInit' })
    Wait(1000) 
    ShutdownLoadingScreenNui()

end)