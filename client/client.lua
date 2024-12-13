local QBCore = exports['qb-core']:GetCoreObject()
local myVehicle = nil

for _, pedCoords in ipairs(Config.Peds.pedSpawner) do
    RequestModel(GetHashKey(pedCoords['hash']))
    while not HasModelLoaded(GetHashKey(pedCoords['hash'])) do
        Wait(0)
    end

    local spawnedPed = CreatePed(2, GetHashKey(pedCoords['hash']), pedCoords.x, pedCoords.y, pedCoords.z - 1.0, pedCoords.h, false, true)
    FreezeEntityPosition(spawnedPed, true)
    SetEntityInvincible(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)

    exports['qb-target']:AddTargetEntity(spawnedPed, { 
        options = { 
            { 
                type = "client", 
                event = "s-cartheft:client:openUI", 
                label = 'Contracts', 
            }
        },
        distance = 2.5, 
    })
end


RegisterNetEvent('s-cartheft:client:openUI', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open'
    })

end)

RegisterNUICallback('closeUI', function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close'
    })
end)


RegisterNUICallback('mission-easy', function(data, cb)
    print("Misja rozpoczęta")
    cb('ok')

    missionStart()
    
end)

RegisterNetEvent('createVehicle', function(vehHash, x, y)
    local modelHash = vehHash
    RequestModel(modelHash)


    local vehicle = CreateVehicle(modelHash, x, y, 24.83151, true, true)
    if DoesEntityExist(vehicle) then
        SetEntityAsMissionEntity(vehicle, true, true)
        local netId = NetworkGetNetworkIdFromEntity(vehicle)

        if NetworkDoesNetworkIdExist(netId) then
            SetNetworkIdExistsOnAllMachines(netId, true)
            myVehicle = vehicle
        end
    end
end)


function missionStart()
    local indexLocation = math.random(1, #Config.spawnLocations)
    local chosenLocation = Config.spawnLocations[indexLocation]
    local indexVehicle = math.random(1, #Config.Vehicles)
    local chosenVehicle = Config.Vehicles[indexVehicle]

    TriggerEvent('createVehicle', chosenVehicle, chosenLocation.x, chosenLocation.y)

    SetNewWaypoint(chosenLocation.x, chosenLocation.y)
end

function missionDelivery()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if not veh or veh == 0 then
        print("No vehicle found.")
        return
    end

    local indexLocation = math.random(1, #Config.deliveryLocations)
    local chosenLocation = Config.deliveryLocations[indexLocation]
    TriggerEvent('QBCore:Notify', "Deliver the vehicle to the marked location!", "success")
    SetNewWaypoint(chosenLocation.x, chosenLocation.y)

    TriggerEvent("startDeliveryMission", veh, chosenLocation.x, chosenLocation.y, chosenLocation.z)
end

RegisterNetEvent('startDeliveryMission')
AddEventHandler('startDeliveryMission', function(veh, deliveryX, deliveryY, deliveryZ)
    local playerPed = PlayerPedId()
    local isMissionActive = true

    Citizen.CreateThread(function()
        while isMissionActive do
            Citizen.Wait(1000)
            if IsPedInAnyVehicle(playerPed, false) then
                local currentVeh = GetVehiclePedIsIn(playerPed, false)
                if currentVeh == veh then
                    local playerCoords = GetEntityCoords(playerPed)
                    local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, deliveryX, deliveryY, deliveryZ)
                    if dist < 20.0 then
                        TriggerEvent('QBCore:Notify', "Vehicle delivered successfully, you recevied your payment!", "success")
                        if DoesEntityExist(veh) and IsPedInAnyVehicle(playerPed, false) then
                            DeleteVehicle(currentVeh)
                        end
                        isMissionActive = false
                        TriggerServerEvent("s-cartheft:server:addMoney")
                    end
                else
                    print("You are no longer in the correct vehicle.")
                end
            else
                TriggerEvent('QBCore:Notify', "You left the vehicle!", "error")

            end
        end
    end)
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh == myVehicle then
                missionDelivery()
                break
            end
        end
    end
end)
