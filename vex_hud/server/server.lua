ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('pepe-hud:server:gain:stress')
AddEventHandler('pepe-hud:server:gain:stress', function(Amount)
    local Player = ESX.GetPlayerFromId(source)
	local NewStress = nil
	if Player ~= nil then
	  TriggerEvent('esx_status:set', 'stress', Amount, function(NewStress))
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 100 then NewStress = 100 end
      TriggerClientEvent("pepe-hud:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)

RegisterServerEvent('pepe-hud:server:remove:stress')
AddEventHandler('pepe-hud:server:remove:stress', function(Amount)
    local Player = ESX.GetPlayerFromId(source)
	local NewStress = nil
	if Player ~= nil then
	  TriggerEvent('esx_status:set', 'stress', Amount, function(NewStress))
	  if NewStress <= 0 then NewStress = 0 end
	  if NewStress > 100 then NewStress = 100 end
      TriggerClientEvent("pepe-hud:client:update:stress", Player.PlayerData.source, NewStress)
	end
end)