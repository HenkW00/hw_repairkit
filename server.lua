ESX = exports["es_extended"]:getSharedObject()

-- ESX = nil

-- TriggerEvent('esx:getSharedObject', function(obj)
--     ESX = obj
-- end)


function CountMechanicsOnline()
    local count = 0
    local players = ESX.GetPlayers()
    for i = 1, #players, 1 do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        if xPlayer and xPlayer.job.name == Config.MechanicJob then
            count = count + 1
        end
    end
    return count
end

ESX.RegisterUsableItem(Config.ItemName, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local mechanicsOnline = CountMechanicsOnline()
    if mechanicsOnline < Config.RequiredMechanicsOnline then
        TriggerClientEvent('hw_repairkit:startRepair', source)
    else
        xPlayer.showNotification('~r~There are enough mechanics online. Please contact one for repairs.')
        if Config.Debug then
            print(('^0[^1DEBUG^0] %s attempted to use a repair kit but %s mechanics are online.'):format(xPlayer.getIdentifier(), mechanicsOnline))
        end
    end
end)

RegisterNetEvent('hw_repairkit:successfulRepair')
AddEventHandler('hw_repairkit:successfulRepair', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.removeInventoryItem(Config.ItemName, 1)
        if Config.Debug then
            print("^0[^1DEBUG^0] Repair kit removed from player inventory after successful repair.")
        end
    end
end)


