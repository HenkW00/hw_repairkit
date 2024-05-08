lib.locale()
ESX = exports["es_extended"]:getSharedObject()

--------------
----NOTIFY----
--------------
local function sendNotification(playerId, message, type, position)
    TriggerClientEvent('hw_repairkit:displayNotification', playerId, message, type, position)
end

---------------
---JOB COUNT---
---------------
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

--------------
---USE ITEM---
--------------
ESX.RegisterUsableItem(Config.ItemName, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local mechanicsOnline = CountMechanicsOnline()
        if mechanicsOnline < Config.RequiredMechanicsOnline then
            local hasRepairKit = xPlayer.getInventoryItem(Config.ItemName)
            if hasRepairKit and hasRepairKit.count > 0 then
                TriggerClientEvent('hw_repairkit:repairVehicle', source)
                if Config.Debug then
                    print("^0[^1DEBUG^0] ^5Player started the repair process.")
                end
            else
                if Config.Notify == 'okokNotify' then
                xPlayer.showNotification('~r~You do not have a repair kit.')
                elseif Config.Notify == 'ox_lib' then
                    sendNotification(source, locale('no_repairkit'), 'error', 'top-left')
                end
            end
        else
            if Config.Notify == 'okokNotify' then
            xPlayer.showNotification('~r~There are enough mechanics online. Please contact one for repairs.')
            elseif Config.Notify == 'ox_lib' then
                sendNotification(source, locale('not_enough_mechanics'), 'info', 'top-left')
            end
            if Config.Debug then
                print(('^0[^1DEBUG^0] ^1%s ^5attempted to use a repair kit but %s mechanics are online.'):format(xPlayer.getIdentifier(), mechanicsOnline))
            end
        end
    else
        print("^0[^1DEBUG^0] ^5Failed to retrieve player object for source: " .. tostring(source))
    end
end)

----------------
---REMOVE KIT---
----------------
RegisterNetEvent('hw_repairkit:removeRepairKit')
AddEventHandler('hw_repairkit:removeRepairKit', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.removeInventoryItem(Config.ItemName, 1)
        if Config.Debug then
            print("^0[^1DEBUG^0] ^5Removed a repair kit from player inventory after successful repair.")
        end
    else
        print("^0[^1DEBUG^0] ^5Failed to remove repair kit from player: " .. tostring(source))
    end
end)