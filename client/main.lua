lib.locale()
ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('hw_containerrobbery:displayNotification')
AddEventHandler('hw_containerrobbery:displayNotification', function(message, type, position)
    lib.notify({
        title = 'Vehicle Repair',
        description = message,
        duration = 3500,
        type = type or 'inform',
        position = position or 'top-right'
    })
end)

---------------
---MAIN LOOP---
---------------
Citizen.CreateThread(function()
    RegisterNetEvent('hw_repairkit:repairVehicle')
    AddEventHandler('hw_repairkit:repairVehicle', function()
        local playerPed = PlayerPedId()
        local vehicle, distance = ESX.Game.GetClosestVehicle()

        -- Check if there is a vehicle and it's within a close range (3 meters).
        if vehicle and distance < 3.0 then
            local initialPos = GetEntityCoords(playerPed)
            local vehiclePos = GetEntityCoords(vehicle)

            -- Validate that the player is within 3 meters of the vehicle.
            if Vdist(initialPos, vehiclePos) < 3.0 then
                if Config.Debug then
                    print("^0[^1DEBUG^0] ^5Starting repair process.")
                end

                FreezeEntityPosition(playerPed, true)
                SetVehicleDoorOpen(vehicle, 4, false, false)
                ESX.Streaming.RequestAnimDict('mini@repair', function()
                    TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8, -1, 49, 0, false, false, false)
                end)

                -- Notification handling based on the configured system.
                if Config.Notify == 'okokNotify' then
                    exports['okokNotify']:Alert("Vehicle Repair", locale('repairing'), Config.RepairTime, 'info')
                elseif Config.Notify == 'ox_lib' then
                    lib.notify({
                        title = 'Vehicle Repair',
                        position = 'top-right',
                        description = locale('repairing'),
                        type = 'success'
                    })
                else
                    error("^1 ERROR: Invalid notification system specified in Config.Notify. Must be either 'okokNotify' or 'ox_lib'.")
                end

                local endTime = GetGameTimer() + Config.RepairTime
                local repairCancelled = false
                while GetGameTimer() < endTime do
                    Citizen.Wait(100)
                    local currentPos = GetEntityCoords(playerPed)
                    if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_ped', 3) or IsPedInAnyVehicle(playerPed, false) or Vdist(initialPos, currentPos) > 1.0 then
                        if Config.Notify == 'okokNotify' then
                            exports['okokNotify']:Alert("Vehicle Repair", locale('cancel_repair'), 5000, 'error')
                        elseif Config.Notify == 'ox_lib' then
                            lib.notify({
                                title = 'Vehicle Repair',
                                position = 'top-right',
                                description = locale('cancel_repair'),
                                type = 'error'
                            })
                        end
                        repairCancelled = true
                        break
                    end
                end

                ClearPedTasks(playerPed)
                FreezeEntityPosition(playerPed, false)

                -- Handling successful repair or cancellation.
                if not repairCancelled then
                    SetVehicleFixed(vehicle)
                    if Config.Notify == 'okokNotify' then
                        exports['okokNotify']:Alert("Vehicle Repair", locale('repair_succesfully'), 5000, 'success')
                    elseif Config.Notify == 'ox_lib' then
                        lib.notify({
                            title = 'Vehicle Repair',
                            position = 'top-right',
                            description = locale('repair_succesfully'),
                            type = 'success'
                        })
                    end
                    SetVehicleDoorsShut(vehicle, false)
                    TriggerServerEvent('hw_repairkit:removeRepairKit')
                    if Config.Debug then
                        print("^0[^1DEBUG^0] ^5Successfully repaired vehicle and removed repair kit.")
                    end
                else
                    SetVehicleDoorShut(vehicle, 4, false)
                end
            else
                -- Notify player if they are not close enough to the vehicle.
                if Config.Notify == 'okokNotify' then
                    exports['okokNotify']:Alert("Vehicle Repair", locale('not_close'), 5000, 'error')
                elseif Config.Notify == 'ox_lib' then
                    lib.notify({
                        title = 'Vehicle Repair',
                        position = 'top-right',
                        description = locale('not_close'),
                        type = 'info'
                    })
                end
            end
        else
            -- Notify player if no vehicle is nearby.
            if Config.Notify == 'okokNotify' then
                exports['okokNotify']:Alert("Vehicle Repair", locale('no_vehicle_nearby'), 5000, 'error')
            elseif Config.Notify == 'ox_lib' then
                lib.notify({
                    title = 'Vehicle Repair',
                    position = 'top-right',
                    description = locale('no_vehicle_nearby'),
                    type = 'error'
                })
            end
        end
    end)
end)