local firstSpawn = true

local peds = {}

local function CreateStorePeds(stores)
    RequestModel("mp_m_shopkeep_01")
    while not HasModelLoaded("mp_m_shopkeep_01") do Wait(0) end
    for i, store in pairs(stores) do
        local pos = store.position
        local ped = CreatePed(4, "mp_m_shopkeep_01", pos.x, pos.y, pos.z, 0.0, true, false)

        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)

    end
    SetModelAsNoLongerNeeded("mp_m_shopkeep_01")
end

AddEventHandler("spawnresource:playerSpawnedClient", function ()
    if firstSpawn == true then
        firstSpawn = false
        CreateStorePeds(Config.Stores)
    end
end)