local QBCore = exports['qb-core']:GetCoreObject()

-- Debugging outputs
local function DebugOutput(data)
    print("Smash Window Event Triggered")
    print("Vehicle Entity: ", data.entity)
end

-- Smash Window Function
local function SmashWindow(data)
    -- Debug output for tracking
    DebugOutput(data)

    -- Validate the entity is a vehicle
    local vehicle = data.entity
    if DoesEntityExist(vehicle) then
        -- Smash the front left window for simplicity
        SetVehicleWindowBroken(vehicle, 0, false)
        QBCore.Functions.Notify("Front left window smashed!", "success")
    else
        QBCore.Functions.Notify("No valid vehicle found", "error")
    end
end

-- Add qb-target interaction for entire vehicle
exports['qb-target']:AddTargetEntity({
    'car', 'bmx', 'truck', 'bus', 'bicycle', 'motorcycle'
}, {
    options = {
        {
            type = "client",
            event = "qb-smash-search:client:SmashWindow",
            icon = "fas fa-car-crash",
            label = "Smash Window",
            action = SmashWindow
        }
    },
    distance = 2.0 -- Set interaction distance for the entire vehicle
})

-- Register client event for smashing window
RegisterNetEvent('qb-smash-search:client:SmashWindow', SmashWindow)
