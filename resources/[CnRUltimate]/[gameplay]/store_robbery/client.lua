local firstSpawn = true

local peds = {}

local function CreateStorePeds(stores)
    RequestModel("mp_m_shopkeep_01")
    while not HasModelLoaded("mp_m_shopkeep_01") do Wait(0) end
    for i, store in pairs(stores) do
        local pos = store.position
        local ped = CreatePed(4, "mp_m_shopkeep_01", pos.x, pos.y, pos.z, pos.w, true, false)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        table.insert(peds, ped)
    end
    SetModelAsNoLongerNeeded("mp_m_shopkeep_01")
end

local function CheckRobbery()
    Citizen.CreateThread(function ()
        
        while true do
            Citizen.Wait(100)
            local playerPed = PlayerPedId()
            local playerJob = exports.datamanager:GetPlayerData().job
            if playerJob ~= "Civilian" then goto continue end
            if GetPedConfigFlag(playerPed, 78) == false then goto continue end

            for i, store in pairs(Config.Stores) do
                
                local playerPos = GetEntityCoords(playerPed)
                local storePos = store.position
                local dist = GetDistanceBetweenCoords(playerPos, storePos)
                if dist <= 3 then
                    exports.notify:Notify("Press [E] to start robbery.")
                    while dist <= 3 do
                        Citizen.Wait(0)
                        playerPos = GetEntityCoords(playerPed)
                        dist = GetDistanceBetweenCoords(playerPos, store.position)
                        if IsControlJustPressed(0, 38) then -- 38 é E por padrão
                            TriggerServerEvent("store_robbery:server:attemptRobbery", i)
                            print("Sended")
                        end
                    end
                end
            end

            ::continue::
        end
    end)
end

Citizen.CreateThread(function ()
    CreateStorePeds(Config.Stores)
    CheckRobbery()
end)