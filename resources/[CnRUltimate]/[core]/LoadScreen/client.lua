print('<<<<< [LOADSCREEN] client.lua FOI EXECUTADO! >>>>>')

-- Ouve o evento REAL de progresso do FiveM
AddEventHandler('loadscreen:onprogress', function(data)
    -- Envia os dados REAIS para o JavaScript a cada passo
    SendNUIMessage({
        type = 'loadProgress',
        progress = data.progress, -- A porcentagem real (0.0 a 1.0)
        loadText = data.loadtext  -- O texto real do que está carregando
    })
end)

-- Lógica para finalizar a tela quando o jogo estiver pronto
CreateThread(function()
    while GetIsLoadingScreenActive() do
        Wait(200)
    end
    -- Avisa o JS que o carregamento acabou
    SendNUIMessage({ type = 'endInit' })
    Wait(1000) -- Espera a animação do seu JS terminar
    ShutdownLoadingScreenNui()

end)