local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('s-cartheft:server:addMoney', function(data)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local playerMoney = xPlayer.PlayerData.money['cash']
    xPlayer.Functions.AddMoney('cash', 5000)



end)