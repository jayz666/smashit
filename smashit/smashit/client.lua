local QBCore = exports['qb-core']:GetCoreObject()

-- Table to store vehicles that have been smashed
local SmashedVehicles = {}
-- Table to store vehicles that have already been searched
local SearchedVehicles = {}

-- Configurable loot table
local LootTable = {
    { item = "lockpick", chance = 40 },  -- 40% chance to get a lockpick
    { item = "cash", chance = 30 },      -- 30% chance to get some cash
    { item = "phone", chance = 10 },     -- 10% chance to get a phone
    { item = "nothing", chance = 20 }    -- 20% chance to find nothing
}

-- Debugging function
local function DebugMessage(message)
    print("^3[SMASHIT DEBUG]:^7 " .. message)
end

-- Function to search a vehicle and give loot
local function SearchVehicle(vehicle)
    -- Debugging: Log that the robbing has started
    DebugMessage("Searching vehicle: " .. tostring(vehicle))

    -- Check if the vehicle has already been searched
    if SearchedVehicles[vehicle] then
        QBCore.Functions.Notify("Stop man, this vehicle has already been searched!", "error")
        DebugMessage("Vehicle already searched: " .. tostring(vehicle))
        return
    end

    -- Determine loot
    local foundItem = GetRandomLoot()

    -- If player found something
    if foundItem ~= "nothing" then
        QBCore.Functions.Notify("You found: " .. foundItem, "success")
        -- Give the player the item (assuming you have QBCore inventory system)
        TriggerServerEvent('QBCore:Server:AddItem', foundItem, 1)
    else
        QBCore.Functions.Notify("You found nothing in the vehicle.", "error")
    end

    -- Mark the vehicle as searched
    SearchedVehicles[vehicle] = true
end

-- Function to start the progress bar and search the vehicle
local function StartSearchProgress(vehicle)
    QBCore.Functions.Progressbar("searching_vehicle", "Searching the vehicle...", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "amb@prop_human_bum_bin@base",
        anim = "base",
        flags = 49,
    }, {}, {}, function() -- On completion
        SearchVehicle(vehicle) -- Make sure this function is called properly
    end, function() -- On cancel
        QBCore.Functions.Notify("Search cancelled.", "error")
    end)
end

-- Function to play smash animation (emote)
local function PlaySmashEmote(playerPed)
    RequestAnimDict("melee@large_wpn@streamed_core") -- Request the animation dictionary

    while not HasAnimDictLoaded("melee@large_wpn@streamed_core") do
        Wait(100)
    end

    -- Play the "melee smash" animation
    TaskPlayAnim(playerPed, "melee@large_wpn@streamed_core", "ground_attack_0", 8.0, 8.0, 3000, 16, 0, false, false, false)
end

-- Function to smash a window and start the search
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

    -- Check if the vehicle has already been smashed
    if SmashedVehicles[vehicle] then
        QBCore.Functions.Notify("This vehicle has already been smashed!", "error")
        DebugMessage("Vehicle already smashed: " .. tostring(vehicle))
        return
    end

    -- Play smash animation (emote)
    PlaySmashEmote(playerPed)

    -- Wait for the animation to finish
    Wait(3000)

    -- Smash the front left window
    SmashVehicleWindow(vehicle, 0)
    QBCore.Functions.Notify("Front left window smashed!", "success")
    DebugMessage("Front left window smashed on vehicle: " .. tostring(vehicle))

    -- Mark the vehicle as smashed
    SmashedVehicles[vehicle] = true

    -- Automatically start searching the vehicle
    StartSearchProgress(vehicle)
end

-- Function to get random loot based on loot table
local function GetRandomLoot()
    local randomChance = math.random(1, 100) -- Generate a random number between 1 and 100
    local cumulativeChance = 0

    -- Loop through the loot table and return the corresponding item
    for _, loot in ipairs(LootTable) do
        cumulativeChance = cumulativeChance + loot.chance
        if randomChance <= cumulativeChance then
            return loot.item
        end
    end

    return "nothing" -- Default to finding nothing
end

-- Add radial menu option for smashing windows
exports['qb-radialmenu']:AddOption({
    id = "smash_window",
    title = "Smash and Rob Vehicle",
    type = "client",
    event = "smashit:client:SmashWindow",
    shouldClose = true
})

-- Register the events for smashing and searching
RegisterNetEvent('smashit:client:SmashWindow', SmashWindow)

