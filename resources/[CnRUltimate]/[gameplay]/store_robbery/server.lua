local storeCooldown = {}

local function startCooldown(storeIndex)

    Citizen.CreateThread(function ()
        while storeCooldown[storeIndex] > 0 do
            Wait(1000)
            storeCooldown[storeIndex] -= 1
        end
        Config.Stores[storeIndex].avaiable = true
    end)

end

RegisterNetEvent("store_robbery:server:attemptRobbery", function (storeIndex)
    local src = source
    local timer = Config.RobberyTime
    Citizen.CreateThread(function ()
        if not Config.Stores[storeIndex] then print("SADAD") return end
        if Config.Stores[storeIndex].avaiable == false then 
            print(storeCooldown)
            TriggerClientEvent("notify:show", src,"This store was recently robbed: Wait: " ..  math.floor(storeCooldown[storeIndex] / 60) .. "m.", "error") 
            return 

        end

        TriggerClientEvent("notify:show", src,"Robbery Started!", "success")
        Config.Stores[storeIndex].avaiable = false
        storeCooldown[storeIndex] = Config.RobberyCooldown
        
        local playerPed = GetPlayerPed(src)
        local storePosition = vector3(Config.Stores[storeIndex].position.x, Config.Stores[storeIndex].position.y, Config.Stores[storeIndex].position.z)
        local dist = #(GetEntityCoords(playerPed) - storePosition)
        while dist <= 10 do
            Citizen.Wait(1000)
            if IsPedDeadOrDying(playerPed, false) then 
                TriggerClientEvent("notify:show", src, "Robbery Failed: You Died", "error")
                startCooldown(storeIndex)
                return
            end
            if playerPed == nil then startCooldown(storeIndex) return end
            dist = #(GetEntityCoords(playerPed) - storePosition)
            if dist > 10 then TriggerClientEvent("notify:show", src,"Robbery Canceled: Left the robbery zone.", "error") startCooldown(storeIndex) return end
            TriggerClientEvent("notify:show", src,"Wait " .. timer .. "s to complete the robbery")
            timer -= 1
            if timer == 0 then
                TriggerClientEvent("notify:show", src,"Robbery Sucess!", "success")
                startCooldown(storeIndex)
                return
            end
        end
        
    end)
end)