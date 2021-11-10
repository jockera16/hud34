local cashAmount = 0
local bankAmount = 0

Framework = nil

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1)
        if Framework == nil then
            TriggerEvent("Framework:getObject", function(obj) Framework = obj end)    
        end
    end
end)

RegisterNetEvent("hud:client:ShowMoney")
AddEventHandler("hud:client:ShowMoney", function(type)
    TriggerEvent("hud:client:SetMoney")
    SendNUIMessage({
        action = "show",
        cash = cashAmount,
        bank = bankAmount,
        type = type,
    })
end)

RegisterNetEvent("pepe-hud:client:money:change")
AddEventHandler("pepe-hud:client:money:change", function(type, amount, isMinus)
    Framework.Functions.GetPlayerData(function(PlayerData)
        CashAmount = PlayerData.money["cash"]
    end)
     SendNUIMessage({
         action = "update",
         cash = CashAmount,
         amount = amount,
         minus = isMinus,
         type = type,
     })
end)
