---------------
---MAIN LOOP---
---------------
Citizen.CreateThread(function()
    RegisterNetEvent('hw_repairkit:repairVehicle')
    AddEventHandler('hw_repairkit:repairVehicle', function()
        local playerPed = PlayerPedId()
        local vehicle, distance = ESX.Game.GetClosestVehicle()

        if vehicle and distance < 3.0 then
            local initialPos = GetEntityCoords(playerPed)
            local vehiclePos = GetEntityCoords(vehicle)

            if Vdist(initialPos, vehiclePos) < 3.0 then
                if Config.Debug then
                    print("^0[^1DEBUG^0] ^5Starting repair process.")
                end

                FreezeEntityPosition(playerPed, true)
                SetVehicleDoorOpen(vehicle, 4, false, false)
                ESX.Streaming.RequestAnimDict('mini@repair', function()
                    TaskPlayAnim(playerPed, 'mini@repair', 'fixing_a_ped', 8.0, -8, -1, 49, 0, false, false, false)
                end)

                exports['okokNotify']:Alert("Vehicle Repair", "Voertuig aan het repareren...", Config.RepairTime, 'info')

                local endTime = GetGameTimer() + Config.RepairTime
                local repairCancelled = false
                while GetGameTimer() < endTime do
                    Citizen.Wait(100)
                    local currentPos = GetEntityCoords(playerPed)
                    if not IsEntityPlayingAnim(playerPed, 'mini@repair', 'fixing_a_ped', 3) or IsPedInAnyVehicle(playerPed, false) or Vdist(initialPos, currentPos) > 1.0 then
                        exports['okokNotify']:Alert("Vehicle Repair", "Voertuig reparatie gestopt!", 5000, 'error')
                        repairCancelled = true
                        break
                    end
                end

                ClearPedTasks(playerPed)
                FreezeEntityPosition(playerPed, false)

                if not repairCancelled then
                    SetVehicleFixed(vehicle)
                    exports['okokNotify']:Alert("Vehicle Repair", "Jouw voertuig is gerepareerd!", 5000, 'success')
                    SetVehicleDoorsShut(vehicle, false)
                    TriggerServerEvent('hw_repairkit:removeRepairKit')
                    if Config.Debug then
                        print("^0[^1DEBUG^0] ^5Successfully repaired vehicle and removed repair kit.")
                    end
                else
                    SetVehicleDoorShut(vehicle, 4, false)
                end
            else
                exports['okokNotify']:Alert("Vehicle Repair", "Je moet dichterbij het voertuig staan.", 5000, 'error')
            end
        else
            exports['okokNotify']:Alert("Vehicle Repair", "Geen voertuig in de buurt", 5000, 'error')
        end
    end)
end)
