-- ESX = exports["es_extended"]:getSharedObject()

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)


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
    if xPlayer then
        local mechanicsOnline = CountMechanicsOnline()
        if mechanicsOnline < Config.RequiredMechanicsOnline then
            local hasRepairKit = xPlayer.getInventoryItem(Config.ItemName)
            if hasRepairKit and hasRepairKit.count > 0 then
                TriggerClientEvent('hw_repairkit:repairVehicle', source)
                if Config.Debug then
                    print("^0[^1DEBUG^0] Player started the repair process.")
                end
            else
                xPlayer.showNotification('~r~You do not have a repair kit.')
            end
        else
            xPlayer.showNotification('~r~There are enough mechanics online. Please contact one for repairs.')
            if Config.Debug then
                print(('^0[^1DEBUG^0] %s attempted to use a repair kit but %s mechanics are online.'):format(xPlayer.getIdentifier(), mechanicsOnline))
            end
        end
    else
        print("^0[^1DEBUG^0] Failed to retrieve player object for source: " .. tostring(source))
    end
end)

RegisterNetEvent('hw_repairkit:removeRepairKit')
AddEventHandler('hw_repairkit:removeRepairKit', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer then
        xPlayer.removeInventoryItem(Config.ItemName, 1)
        if Config.Debug then
            print("^0[^1DEBUG^0] Removed a repair kit from player inventory after successful repair.")
        end
    else
        print("^0[^1DEBUG^0] Failed to remove repair kit from player: " .. tostring(_source))
    end
end)
