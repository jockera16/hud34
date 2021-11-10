local speed = 0.0
local Seatbelt = false
local cruiseOn = false
local ShowHud = false

local Hunger, Thirst, Stress = 100, 100, 0

function CalculateTimeToDisplay()
	hour = GetClockHours()
    minute = GetClockMinutes()
    
    local obj = {}
    
	if minute <= 9 then
		minute = "0" .. minute
    end
    
	if hour <= 9 then
		hour = "0" .. hour
    end
    
    obj.hour = hour
    obj.minute = minute

    return obj
end

posX = 0.01
posY = 0.0-- 0.0152

width = 0.183
height = 0.32--0.354

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function()
    Citizen.SetTimeout(750, function()
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)    
        TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
        TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
	TriggerEvent('esx_status:getStatus', 'stress', function(stress)
        Citizen.Wait(250)
        showRoundMap()
        ESX.GetPlayerData(function(PlayerData)
            if PlayerData ~= nil then
		local myhunger = hunger.getPercent()
		local mythirst = thirst.getPercent()
		local mystress = stress.getPercent()
            end
        end)
	end)
	end)
	end)
        ShowHud = true
        isLoggedIn = true
    end)
end)

RegisterNetEvent("pepe-hud:client:update:needs")
AddEventHandler("pepe-hud:client:update:needs", function(NewHunger, NewThirst)
    Hunger, Thirst = NewHunger, NewThirst
end)

RegisterNetEvent('pepe-hud:client:update:stress')
AddEventHandler('pepe-hud:client:update:stress', function(NewStress)
    Stress = NewStress
end)

showRoundMap = function()
    RequestStreamedTextureDict("circlemap", false)
    while not HasStreamedTextureDictLoaded("circlemap") do
        Wait(100)
    end

    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

    SetMinimapClipType(1)
    SetMinimapComponentPosition('minimap', 'L', 'B', posX, posY, width, height)
    --SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0, 0.032, 0.101, 0.259)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', posX, posY, width, height)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.015, 0.022, 0.256, 0.337)

    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        SetBlipAlpha(GetNorthRadarBlip(), 0)
    end
end

Citizen.CreateThread(function()
    Citizen.Wait(2500)
    while true do 
        if ESX ~= nil and isLoggedIn and Config.Show then
	    TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
	    TriggerEvent('esx_status:getStatus','stress',function(stress)
            local Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))) * 3.6
            local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)))
            local engine = GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1)))
	    local mythirst = thirst.getPercent()
	    local myhunger = hunger.getPercent()
	    local mystress = stress.getPercent()
            SendNUIMessage({
                action = "hudtick",
                show = IsPauseMenuActive(),
                --[[radio = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'radio:talking'),
                talking = exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:talking'),]]
                health = GetEntityHealth(GetPlayerPed(-1)),
                armor = GetPedArmour(GetPlayerPed(-1)),
                thirst = mythirst,
                hunger = myhunger,
                stress = mystress,
                seatbelt = Seatbelt,
                speed = math.ceil(Speed),
                fuel = exports['np-fuel']:GetFuel(Plate),
                engine = engine,
            })
	    end)
	    end)
	    end)
            Citizen.Wait(10)
        else
            Citizen.Wait(10)
        end
    end
end)

RegisterNetEvent("pepe-hud:client:set:values")
AddEventHandler("pepe-hud:client:set:values", function()
    Citizen.SetTimeout(1000, function()
            local Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1))) * 3.6
            local Plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1)))
            local engine = GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1)))
            TriggerEvent('esx_status:getStatus', 'hunger', function(hunger)
            TriggerEvent('esx_status:getStatus', 'thirst', function(thirst)
	    TriggerEvent('esx_status:getStatus','stress',function(stress)
	    local mythirst = thirst.getPercent()
	    local myhunger = hunger.getPercent()
	    local mystress = stress.getPercent()
            SendNUIMessage({
                action = "hudtick",
                show = IsPauseMenuActive(),
                -- Player --
--[[                radio = exports.tokovoip_script:GetPlayerServerId(PlayerId(), 'radio:talking'),
                talking = exports.tokovoip_script:GetPlayerServerId(PlayerId(), 'voip:talking'), ]]
                health = GetEntityHealth(GetPlayerPed(-1)),
                armor = GetPedArmour(GetPlayerPed(-1)),
                thirst = mythirst,
                hunger = myhunger,
                stress = mystress,
                speed = math.ceil(Speed),
                fuel = exports['np-fuel']:GetFuel(Plate),
                engine = engine,
            })
            if not PlayerData.metadata["isdead"] then
              SetEntityHealth(GetPlayerPed(-1), PlayerData.metadata["health"])
              SetPedArmour(GetPlayerPed(-1), PlayerData.metadata["armor"])
	    end
	    end)
	    end)
            end)
        --end)
    end)
end)


local radarActive = false
Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(1000)
        if IsPedInAnyVehicle(PlayerPedId()) and isLoggedIn and Config.Show then
            DisplayRadar(true)
            SendNUIMessage({
                action = "car",
                show = true,
            })
            radarActive = true
        else
            DisplayRadar(false)
            SendNUIMessage({
                action = "car",
                show = false,
            })

            SendNUIMessage({
                action = "seatbelt",
                seatbelt = Seatbelt,
            })
            radarActive = false
        end
    end
end)

RegisterNetEvent("pepe-hud:client:update:needs")
AddEventHandler("pepe-hud:client:update:needs", function(NewHunger, NewThirst)
    Hunger, Thirst = NewHunger, NewThirst
end)

RegisterNetEvent('pepe-hud:client:update:stress')
AddEventHandler('pepe-hud:client:update:stress', function(NewStress)
    Stress = NewStress
end)

function SetSeatbelt(bool)
    Seatbelt = bool
end

Citizen.CreateThread(function()
    while true do
      Citizen.Wait(5)
      if isLoggedIn then
          local Wait = GetEffectInterval(Stress)
          if Stress >= 100 then
              local ShakeIntensity = GetShakeIntensity(Stress)
              local FallRepeat = math.random(2, 4)
              local RagdollTimeout = (FallRepeat * 1750)
              ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
              SetFlash(0, 0, 500, 3000, 500)
              if not IsPedRagdoll(GetPlayerPed(-1)) and IsPedOnFoot(GetPlayerPed(-1)) and not IsPedSwimming(GetPlayerPed(-1)) then
                  SetPedToRagdollWithFall(PlayerPedId(), RagdollTimeout, RagdollTimeout, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
              end
              Citizen.Wait(500)
              for i = 1, FallRepeat, 1 do
                  Citizen.Wait(750)
                  DoScreenFadeOut(200)
                  Citizen.Wait(1000)
                  DoScreenFadeIn(200)
                  ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
                  SetFlash(0, 0, 200, 750, 200)
              end
          elseif Stress >= Config.MinimumStress then
              local ShakeIntensity = GetShakeIntensity(Stress)
              ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', ShakeIntensity)
              SetFlash(0, 0, 500, 2500, 500)
          end
          Citizen.Wait(Wait)
      end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(30)
        if isLoggedIn then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                local CurrentSpeed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6
                if CurrentSpeed >= 180 then
                    TriggerServerEvent('pepe-hud:server:gain:stress', math.random(1, 2))
                end
            end
        end
        Citizen.Wait(20000)
    end
end)

function GetShakeIntensity(stresslevel)
    local retval = 0.05
    for k, v in pairs(Config.Intensity["shake"]) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.intensity
            break
        end
    end
    return retval
end

function GetEffectInterval(stresslevel)
    local retval = 60000
    for k, v in pairs(Config.EffectInterval) do
        if stresslevel >= v.min and stresslevel < v.max then
            retval = v.timeout
            break
        end
    end
    return retval
end

Citizen.CreateThread(function()
    local CurrentLevel = 1
    while true do
        Citizen.Wait(3)
        if IsControlJustReleased(1, 243) then
            CurrentLevel =  exports.tokovoip_script:getPlayerData(GetPlayerServerId(PlayerId()), 'voip:mode')
			--CurrentLevel = 1
            if CurrentLevel == 1 then
                SendNUIMessage({
                    action = "UpdateProximity",
                    prox = 2
                })
            elseif CurrentLevel == 2 then
                SendNUIMessage({
                    action = "UpdateProximity",
                    prox = 1
                })
            elseif CurrentLevel == 3 then
                SendNUIMessage({
                    action = "UpdateProximity",
                    prox = 3
                })
            end
        end
    end
end)

--[[
function RequestMapOverlay()
    print('Setup map?!@?')
	RequestStreamedTextureDict("circlemap", false)
	while not HasStreamedTextureDictLoaded("circlemap") do
		Wait(100)
	end

	AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

	SetMinimapClipType(1)
	SetMinimapComponentPosition('minimap', 'L', 'B', 0.019, 0.02, 0.150, 0.300)
	SetMinimapComponentPosition("minimap_mask", "L", "B", 0.019, 0.02, 0.150, 0.300)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', 0.015, 0.005, 0.225, 0.300)

    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)

    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    end
end
]]--