local QBCore = exports['qb-core']:GetCoreObject()
local myVehicle = nil

for _, pedCoords in ipairs(Config.Peds.locations) do
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

RegisterNetEvent('createVehicle', function(vehHash, x, y, z)
    local modelHash = vehHash
    RequestModel(modelHash)
    local vehicle = CreateVehicle(modelHash, x, y, z, true, true)
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

    TriggerEvent('createVehicle', chosenVehicle, chosenLocation.x, chosenLocation.y, chosenLocation.z)
    TriggerEvent('QBCore:Notify', "The location has been marked!", "success")


    SetNewWaypoint(chosenLocation.x, chosenLocation.y)
    TriggerServerEvent("s-cartheft:server:spawnNPC", chosenLocation)

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

function spawnNPC(coords)
    local npcModels = {
        "g_m_importexport_01", 
        "g_m_m_armgoon_01",  
        "u_m_y_babyd",       
        "g_m_m_chigoon_01",    
        "g_m_y_korean_01",    
        "g_m_m_chigoon_02",    
        "g_m_m_korboss_01",    
        "g_m_y_korean_02" 

    }
    local maxAmount = Config.MaxHostileAmount
    local amount = math.random(1, maxAmount)


    for i = 1, amount do
        local randomIndex = math.random(1, #npcModels)
        local model = npcModels[randomIndex]

        RequestModel(GetHashKey(model))
        while HasModelLoaded(GetHashKey(model)) == false do
            Wait(100)
        end
        local offsetX = math.random(-7, 7)
        local offsetY = math.random(-7, 7)


        local npc = CreatePed(4, GetHashKey(model), coords.x + offsetX, coords.y - offsetY, coords.z, 0.0, true, true)
        SetPedCombatAttributes (npc, 46, true)
        SetPedCombatAbility(npc, 2)
        SetPedCombatRange(npc, 2)
        SetPedFleeAttributes(npc, 0, false)
        SetPedAccuracy(npc, 70)

        local playerPed = PlayerPedId()
        TaskCombatPed(npc, playerPed, 0, 16)
        -- GiveWeaponToPed(npc, GetHashKey("WEAPON_PISTOL"), 50, false, true)

    end
end



RegisterNetEvent("spawnNPC")
AddEventHandler("spawnNPC", function(coords)
    spawnNPC(coords)
end)

RegisterNetEvent('startDeliveryMission')
AddEventHandler('startDeliveryMission', function(veh, deliveryX, deliveryY, deliveryZ)
    local playerPed = PlayerPedId()
    local isMissionActive = true
    local amount = Config.Payment

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
                        TriggerServerEvent("s-cartheft:server:addMoney", amount)
                    end
                end
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
                print("You are in the scripted vehicle.")
                missionDelivery()
                break
            end
        end
    end
end)

