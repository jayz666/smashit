local QBCore = exports['qb-core']:GetCoreObject()

-- Debugging function
local function DebugMessage(message)
    print("^3[SMASHIT DEBUG]:^7 " .. message)
end

-- Smash window function triggered from radial menu
local function SmashWindow()
    local playerPed = PlayerPedId()
    local vehicle = GetClosestVehicle(GetEntityCoords(playerPed), 5.0, 0, 70)
    
    -- Debugging: Log the vehicle entity ID
    DebugMessage("SmashWindow triggered, vehicle: " .. tostring(vehicle))
    
    -- Ensure that the vehicle entity is valid
    if not vehicle or not DoesEntityExist(vehicle) then
        QBCore.Functions.Notify("No valid vehicle nearby.", "error")
        DebugMessage("No valid vehicle found.")
        return
    end

    -- Use SmashVehicleWindow instead of SetVehicleWindowBroken
    SmashVehicleWindow(vehicle, 0) -- 0 refers to the front left window
    QBCore.Functions.Notify("Front left window smashed!", "success")
    DebugMessage("Front left window smashed on vehicle: " .. tostring(vehicle))
end

-- Add radial menu option for smashing windows
exports['qb-radialmenu']:AddOption({
    id = "smash_window",
    title = "Smash Window",
    type = "client",
    event = "smashit:client:SmashWindow",
    shouldClose = true
})

-- Register the event that will be triggered by the radial menu
RegisterNetEvent('smashit:client:SmashWindow', SmashWindow)

