Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        SetPedPopulationBudget(Config._populationDense)
        SetVehiclePopulationBudget(Config._vehicleDense)
        SetScenarioPedDensityMultiplierThisFrame(Config._scenarioPedDense, Config._scenarioPedDense)
        SetParkedVehicleDensityMultiplierThisFrame(Config._parkedVehicleDense)
    end
end)