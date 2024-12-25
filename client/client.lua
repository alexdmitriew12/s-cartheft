local QBCore = exports['qb-core']:GetCoreObject()
local myVehicle = nil
local missionActive = false

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


local function createBlip(blipX, blipY, blipZ, radius)
    if missionActive then
        blipRadius = AddBlipForRadius(blipX, blipY, blipZ, radius)
        SetBlipColour(blipRadius, 1)
        SetBlipAlpha(blipRadius, 128)

        nameBlip = AddBlipForCoord(blipX, blipY, blipZ)
        SetBlipSprite(nameBlip, 229) 
        SetBlipColour(nameBlip, 5)
        SetBlipScale(nameBlip, 0.75)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Vehicle Search Zone")
        EndTextCommandSetBlipName(nameBlip)
    else
        if DoesBlipExist(blipRadius) then
            RemoveBlip(blipRadius)
            blipRadius = nil
        end

        if DoesBlipExist(nameBlip) then
            RemoveBlip(nameBlip)
            nameBlip = nil
        end
    end
end


local function missionStart(missionType)
    local chosenVehicles = {}

    if missionType == "easy" then
        chosenVehicles = Config.CivilianVehicles
    elseif missionType == "medium" then
        chosenVehicles = Config.GangVehicles
    elseif missionType == "hard" then
        chosenVehicles = Config.MilitaryVehicles
    end

    local zoneIndex = math.random(1, #Config.Zones)
    local chosenZone = Config.Zones[zoneIndex]

    local spawnIndex = math.random(1, #chosenZone.spawns)
    local spawnPoint = chosenZone.spawns[spawnIndex]

    local indexVehicle = math.random(1, #chosenVehicles)
    local chosenVehicle = chosenVehicles[indexVehicle]

    local displayName = GetDisplayNameFromVehicleModel(chosenVehicle)
    local vehicleName = GetLabelText(displayName)

    missionActive = true
    TriggerEvent('createVehicle', chosenVehicle, spawnPoint.x, spawnPoint.y, spawnPoint.z)
    TriggerEvent('QBCore:Notify', "The location has been marked, your vehicle: " .. vehicleName, "success")

    createBlip(chosenZone.center.x, chosenZone.center.y, chosenZone.center.z, chosenZone.radius)

    if missionType == "medium" or missionType == "hard" then
        TriggerServerEvent("s-cartheft:server:spawnNPC", spawnPoint, missionType)
    end
end


RegisterNUICallback('mission-easy', function(data, cb)
    missionStart("easy")
end)

RegisterNUICallback('mission-medium', function(data, cb)
    missionStart("medium")
end)

RegisterNUICallback('mission-hard', function(data, cb)
    missionStart("hard")
end)


RegisterNetEvent('createVehicle', function(vehHash, x, y, z)
    if myVehicle then
        if DoesEntityExist(myVehicle) then
            DeleteVehicle(myVehicle)
        end
    end

    local modelHash = vehHash
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(100)
    end

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





local function PoliceCall()
    local random = math.random(1, 100)
    if random <= Config.PoliceCallChance then
        TriggerServerEvent('police:server:policeAlert', 'Vehicle theft')
    end
end

local function missionDelivery()
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if not veh or veh == 0 then
        print("No vehicle found.")
        return
    end

    local indexLocation = math.random(1, #Config.deliveryLocations)
    local chosenLocation = Config.deliveryLocations[indexLocation]
    TriggerEvent('QBCore:Notify', "Deliver the vehicle to the marked location!", "success")
    SetNewWaypoint(chosenLocation.x, chosenLocation.y)
    PoliceCall()

    TriggerEvent("startDeliveryMission", veh, chosenLocation.x, chosenLocation.y, chosenLocation.z)
end

local function spawnNPC(coords, missionType)
    local GangNpcModels = {
        "g_m_importexport_01",
        "g_m_m_armgoon_01",
        "u_m_y_babyd",
        "g_m_m_chigoon_01",
        "g_m_y_korean_01",
        "g_m_m_chigoon_02",
        "g_m_m_korboss_01",
        "g_m_y_korean_02"
    }

    local MilitaryNpcModels = {
        "s_m_y_blackops_01",
        "s_m_y_blackops_02",
        "s_m_y_blackops_03"
    }

    local npcModels = {}
    local maxAmount = 1 
    local weaponList = {} 


    if missionType == "medium" then
        npcModels = GangNpcModels
        maxAmount = Config.MediumMaxHostileAmount
        weaponList = Config.WeaponList.medium
    elseif missionType == "hard" then
        npcModels = MilitaryNpcModels
        maxAmount = Config.HardMaxHostileAmount
        weaponList = Config.WeaponList.hard
    else
        print("Invalid mission type: " .. tostring(missionType))
        return
    end

    local amount = math.random(1, maxAmount)

    for i = 1, amount do
        local randomIndex = math.random(1, #npcModels)
        local model = npcModels[randomIndex]

        local weaponIndex = math.random(1, #weaponList)
        local chosenWeapon = weaponList[weaponIndex]

        RequestModel(GetHashKey(model))
        while not HasModelLoaded(GetHashKey(model)) do
            Wait(100)
        end

        local offsetX = math.random(-10, 10)
        local offsetY = math.random(-10, 10)

        local npc = CreatePed(4, GetHashKey(model), coords.x + offsetX, coords.y + offsetY, coords.z, 0.0, true, true)
        SetPedCombatAttributes(npc, 46, true)
        SetPedCombatAbility(npc, 2)
        SetPedCombatRange(npc, 2)
        SetPedFleeAttributes(npc, 0, false)
        SetPedAccuracy(npc, 70)

        GiveWeaponToPed(npc, GetHashKey(chosenWeapon), 9999, false, true)

        local playerPed = PlayerPedId()
        TaskCombatPed(npc, playerPed, 0, 16)
    end
end








RegisterNetEvent("spawnNPC")
AddEventHandler("spawnNPC", function(coords, missionType)
    spawnNPC(coords, missionType)
end)

RegisterNetEvent('startDeliveryMission')
AddEventHandler('startDeliveryMission', function(veh, deliveryX, deliveryY, deliveryZ)
    local playerPed = PlayerPedId()
    local amount = Config.Payment
    missionActive = true

    Citizen.CreateThread(function()
        while missionActive do
            Citizen.Wait(1000)
            if IsPedInAnyVehicle(playerPed, false) then
                local currentVeh = GetVehiclePedIsIn(playerPed, false)
                if currentVeh == veh then
                    local playerCoords = GetEntityCoords(playerPed)
                    local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, deliveryX, deliveryY, deliveryZ)
                    if dist < 20.0 then
                        TriggerEvent('QBCore:Notify', "Vehicle delivered successfully, you received your payment!", "success")
                        if DoesEntityExist(veh) then
                            DeleteVehicle(currentVeh)
                        end
                        missionActive = false
                        createBlip(0, 0, 0, 0) 
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
                missionDelivery()
                break
            end
        end
    end
end)

