local QBCore = exports['qb-core']:GetCoreObject()

-- Server-side event to handle vehicle search
RegisterNetEvent('qb-smash-search:server:SearchVehicle', function(netId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Random loot system
    local loot = math.random(1, 5)
    if loot == 1 then
        Player.Functions.AddItem('lockpick', 1)
        TriggerClientEvent('QBCore:Notify', src, "You found a lockpick!", "success")
    elseif loot == 2 then
        Player.Functions.AddItem('bread', 1)
        TriggerClientEvent('QBCore:Notify', src, "You found some bread!", "success")
    elseif loot == 3 then
        Player.Functions.AddItem('water', 1)
        TriggerClientEvent('QBCore:Notify', src, "You found a water bottle!", "success")
    else
        TriggerClientEvent('QBCore:Notify', src, "Nothing found!", "error")
    end
end)

