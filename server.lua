ESX = exports["es_extended"]:getSharedObject()

-- ESX = nil

-- TriggerEvent('esx:getSharedObject', function(obj)
--     ESX = obj
-- end)

function CountMechanicsOnline()
    local count = 0
    local players = ESX.GetPlayers()
    for i=1, #players, 1 do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        if xPlayer.job.name == Config.MechanicJob then
            count = count + 1
        end
    end
    return count
end

ESX.RegisterUsableItem(Config.ItemName, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local mechanicsOnline = CountMechanicsOnline()
        if mechanicsOnline < Config.RequiredMechanicsOnline then
            local hasRepairKit = xPlayer.getInventoryItem(Config.ItemName)
            if hasRepairKit.count > 0 then
                if Config.Inventory == 'normal' then
                    xPlayer.removeInventoryItem(Config.ItemName, 1)
                elseif Config.Inventory == 'ox_inventory' then
                    TriggerEvent('ox_inventory:removeItem', source, Config.ItemName, 1)
                end
                TriggerClientEvent('hw_repairkit:repairVehicle', source)
            else
                xPlayer.showNotification('~r~You do not have a repair kit.')
            end
        else
            xPlayer.showNotification('~r~There are enough mechanics online. Please contact one for repairs.')
            if Config.Debug then
                print(('hw_repairkit: %s attempted to use a repair kit but %s mechanics are online.'):format(xPlayer.getIdentifier(), mechanicsOnline))
            end
        end
    else
        print("Failed to retrieve player object for source:", source) -- Debugging statement
    end
end)


RegisterNetEvent('ox_inventory:removeItem')
AddEventHandler('ox_inventory:removeItem', function(source, itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.removeInventoryItem(itemName, amount)
    else
        print("Failed to retrieve player object for source:", source) -- Debugging statement
    end
end)
