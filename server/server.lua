local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('s-cartheft:server:addMoney', function(amount)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local playerMoney = xPlayer.PlayerData.money['cash']
    xPlayer.Functions.AddMoney('cash', amount)
end)

RegisterNetEvent('s-cartheft:server:spawnNPC')
AddEventHandler('s-cartheft:server:spawnNPC', function(location)
    if location ~= nil then
        TriggerClientEvent('spawnNPC', -1, location)
    else
        print("Error: Location is nil")
    end
end)