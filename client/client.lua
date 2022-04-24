ToggleHUD = true -- CHANGE THIS VALUE TO FALSE IF YOU WANT TO DON'T SHOW THE HUD
player = PlayerPedId()
health = (GetEntityHealth(player) - 100)
armor = GetPedArmour(player)
oldthirst, oldhunger, oldstress = 100, 100, 0
newthirst, newhunger, newstress = 100, 100, 0
myammo, myvoice, oxy, minimap, carSpeed, engineH = 0, 65, nil, nil, nil, nil
hasVehKeys, istalking, hasSeatbelt = false, false, false

if Config.UseFramework == 'ESX' then
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
            Citizen.Wait(10)
        end
        GetValues()
    end)

    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        GetValues()
    end)
elseif Config.UseFramework == 'QBCore' then
    -- MAKING IT SOON
elseif Config.UseFramework == 'Custom' then
    -- INSERT THERE YOUR OWN EVENTS FOR START
end

RegisterCommand('hud', function(source, args, rawCommand)
    if ToggleHUD then
        ToggleHUD = false
    elseif not ToggleHUD then
        ToggleHUD = true
    end
end)

function GetVehHealthPercent()
	local ped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsUsing(ped)
	local vehiclehealth = GetEntityHealth(vehicle) - 100
	local maxhealth = GetEntityMaxHealth(vehicle) - 100
	local procentage = (vehiclehealth / maxhealth) * 100
	return procentage
end

function SpeedVerification()
    local PlayerPed = PlayerPedId()
    local PedCar = GetVehiclePedIsIn(PlayerPed, false)
    local newspeed = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(player, false)) * 3.6)
    local veloc = GetEntityVelocity(PedCar)
    if (carSpeed >= Config.MaxSpeed) and (carSpeed ~= (newspeed/0.2)) and not hasSeatbelt then
        SetEntityCoords(PlayerPed, GetOffsetFromEntityInWorldCoords(PedCar, 1.0, 0.0, 1.0))
        SetPedToRagdoll(PlayerPed, 10000, 10000, 0, 0, 0, 0)
        SetEntityVelocity(PlayerPed, veloc.x*4,veloc.y*4,veloc.z*4)
        hasSeatbelt = false

        if (GetEntityHealth(PlayerPed) > 0) then
            RequestAnimDict("dead")
            RequestAnimSet("move_m@injured")
            SetPedMovementClipset(PlayerPed, "move_m@injured", true)
        end
    end
end

function VehicleHUD()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        DisplayRadar(true)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
    else
        if hasSeatbelt then hasSeatbelt = not hasSeatbelt end
        DisplayRadar(false)
    end
end

function GetValues()
    if Config.UseFramework == 'ESX' then
        ESX.TriggerServerCallback('slayn_hud:GetStatus', function(thirst, hunger, stress)
            oldthirst = thirst
            oldhunger = hunger
            oldstress = stress
            print("Thirst: " .. oldthirst .. "\n" .. "Hunger: " .. oldhunger .. "\n" .. "Stress: " .. oldstress)
        end, oldthirst, oldhunger, oldstress)
    elseif Config.UseFramework == 'QBCore' then
        -- MAKING IT
    elseif Config.UseFramework == 'Custom' then
        -- INSERT YOUR SERVER CALLBACK FOR VALUES
    end
end

function PlayerNeeds()
    if Config.UseFramework == 'ESX' then
        ESX.TriggerServerCallback('slayn_hud:UpdateStatus', function(thirst, hunger, stress)
            newthirst = thirst
            newhunger = hunger
            newstress = stress
            print("Thirst: " .. newthirst .. "\n" .. "Hunger: " .. newhunger .. "\n" .. "Stress: " .. newstress)
        end, oldthirst, oldhunger, oldstress)
    elseif Config.UseFramework == 'QBCore' then
        -- MAKING IT
    elseif Config.UseFramework == 'Custom' then
        -- INSERT YOUR SERVER CALLBACK FOR VALUES
    end
end

---- SEATBELT ----
RegisterCommand('seatbelt', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        if Config.EnableSeatbeltSound then
            if hasSeatbelt then
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'noseatbelt', 0.3)
            else
                TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'seatbelt', 0.3)
            end
        end
        hasSeatbelt = not hasSeatbelt
    end
end)

RegisterKeyMapping('seatbelt', 'Vehicle Seatbelt', 'keyboard', Config.SeatbeltKeyBind)

---- STATUS ----
function GetStatus()
    if NetworkIsPlayerTalking(PlayerId()) then
        istalking = true
    else
        istalking = false
    end
    Citizen.Wait(Config.TickTimeInto)
    if IsPedOnFoot(player) then
        if IsPedSwimmingUnderWater(player) then
            oxy = (GetPlayerUnderwaterTimeRemaining(PlayerId())*10)
            if oxy <= 0.0 and health >= 1 then
                SetEntityHealth(player, 0)
            end
        else
            oxy = 100.0 - (GetPlayerSprintStaminaRemaining(PlayerId()))
        end
    else
        oxy = 100
    end
    Citizen.Wait(Config.TickTimeInto)
    if IsPedArmed(PlayerPedId(), 4) then
        local ammo = GetAmmoInClip(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()))
        if ammo then
            myammo = 100
        else
            myammo = 0
        end
    else
        myammo = 0
    end
    Citizen.Wait(Config.TickTimeInto)
    if (newthirst > oldthirst) or (newhunger > oldhunger) or (newstress > oldstress) then
        PlayerNeeds()
    end
end

---- SET EXPORTS ----

exports('setTalking', function(value)
    istalking = value
end)

exports('setVolume', function(value)
    if value == Config.VoiceStates.normal then
        myvoice = 65
    elseif value == Config.VoiceStates.shout then
        myvoice = 100
    elseif value == Config.VoiceStates.whisper then
        myvoice = 35
    end
end)

exports('setThirst', function(value)
    oldthirst, newthirst = value, value
end)

exports('setHunger', function(value)
    oldhunger, newhunger = value, value
end)

exports('setStress', function(value)
    oldstress, newstress = value, value
end)

---- ADD EXPORTS ----
exports('addThirst', function(value)
    oldthirst, newthirst = oldthirst + value, newthirst + value
end)

exports('addHunger', function(value)
    oldhunger, newhunger = oldhunger + value, newhunger + value
end)

exports('addStress', function(value)
    oldstress, newstress = oldstress + value, newstress + value
end)

---- REMOVE EXPORTS ----
exports('removeThirst', function(value)
    oldthirst, newthirst = oldthirst - value, newthirst - value
end)

exports('removeHunger', function(value)
    oldhunger, newhunger = oldhunger - value, newhunger - value
end)

exports('removeStress', function(value)
    oldstress, newstress = oldstress - value, newstress - value
end)

---- RADAR THREAD ----
Citizen.CreateThread(function()
    local defaultAspectRatio = 1920/1080
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX/resolutionY
    local minimapOffset = 0
    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio-aspectRatio)/3.6)-0.008
    end
    Citizen.Wait(100)
    if Config.CircularRadar == true then
	    RequestStreamedTextureDict("circlemap", false)
	    while not HasStreamedTextureDictLoaded("circlemap") do
		    Wait(1)
	    end
	    AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "circlemap", "radarmasksm")

	    SetMinimapClipType(1)
	    SetMinimapComponentPosition("minimap", "L", "B", 0 + minimapOffset + 0.017, -0.05, 0.153, 0.24)
	    SetMinimapComponentPosition("minimap_mask", "L", "B", 0 + minimapOffset + 0.127, 0.12, 0.093, 0.164)
	    SetMinimapComponentPosition("minimap_blur", "L", "B", 0 + minimapOffset + 0.004, 0.022, 0.256, 0.337)
	    SetBlipAlpha(GetNorthRadarBlip(), 0)
        minimap = RequestScaleformMovie("minimap")
        SetRadarBigmapEnabled(true, false)
        Wait(1)
        SetRadarBigmapEnabled(false, false)
    else
        RequestStreamedTextureDict("squaremap", false)
        if not HasStreamedTextureDictLoaded("squaremap") then
            Wait(1)
        end
        SetMinimapClipType(0)
        AddReplaceTexture("platform:/textures/graphics", "radarmasksm", "squaremap", "radarmasksm")
        AddReplaceTexture("platform:/textures/graphics", "radarmask1g", "squaremap", "radarmasksm")
        SetMinimapComponentPosition("minimap", "L", "B", 0.0 + minimapOffset, -0.047, 0.1638, 0.183)
        SetMinimapComponentPosition("minimap_mask", "L", "B", 0.0 + minimapOffset, 0.0, 0.128, 0.20)
        SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01 + minimapOffset, 0.025, 0.262, 0.300)
        SetBlipAlpha(GetNorthRadarBlip(), 0)
        minimap = RequestScaleformMovie("minimap")
        SetRadarBigmapEnabled(true, false)
        SetMinimapClipType(0)
        Wait(1)
        SetRadarBigmapEnabled(false, false)
    end
end)


---- MAIN THREAD ----
Citizen.CreateThread(function()
    while true do
        player = PlayerPedId()
        health = (GetEntityHealth(player) - 100)
        armor = GetPedArmour(player)
        carSpeed = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(player, false)) * 3.6)
        engineH = GetVehHealthPercent(GetVehiclePedIsIn(player, false))
        if Config.EnableFuelScript == true and IsPedInAnyVehicle(player, false) then
            VehFuel = Config.VehicleFuelEvent
        elseif Config.EnableFuelScript == false and IsPedInAnyVehicle(player, false) then
            VehFuel = GetVehicleFuelLevel(GetVehiclePedIsIn(player, false))
        end
        if Config.EnableVehicleKeys == true then
            hasVehKeys = Config.VehicleKeysEvent
        else
            hasVehKeys = true
        end
        VehicleHUD()
        GetStatus()
        SpeedVerification()
        if ToggleHUD then
            if not IsPauseMenuActive() then
                SendNUIMessage({
                    action = 'updateStatusHud',
                    show = ToggleHUD,
                    type = Config.CustomType,
                    incar = IsPedInAnyVehicle(player, false),
                    speed = carSpeed,
                    fuel = VehFuel,
                    haskeys = hasVehKeys,
                    engine = engineH,
                    seatbelt = hasSeatbelt,
                    voice =  myvoice,
                    talking = istalking,
                    health = health,
                    armour = armor,
                    oxygen = oxy,
                    hunger = newhunger,
                    thirst = newthirst,
                    stress = newstress,
                    ammo = myammo,
                })
            else
                SendNUIMessage({
                    action = 'updateStatusHud',
                    show = ToggleHUD,
                })
            end
        else
            SendNUIMessage({
                action = 'updateStatusHud',
                show = ToggleHUD,
            })
        end
        Citizen.Wait(Config.ReloadTime)
    end
end)

---- UPDATE THREAD ----
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.NeedsUpdate)
        if oldthirst > 0 then
            oldthirst = oldthirst - Config.ThirstQuantity
        end
        if oldhunger > 0 then
            oldhunger = oldhunger - Config.HungerQuantity
        end
        if oldthirst <= 0 or oldhunger <= 0 then
            local pHealth = GetEntityHealth(PlayerPedId())
            local nHealth = pHealth - Config.HealthQuantity
            SetEntityHealth(PlayerPedId(), nHealth)
        end
    end
end)

---- FUEL FUNCTION IF NOT FUEL EVENT ----
Citizen.CreateThread(function()
	while true do
      if not Config.EnableFuelScript then
		local Ped = PlayerPedId()
		if(IsPedInAnyVehicle(Ped)) then
			local PedCar = GetVehiclePedIsIn(Ped, false)
				carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
				fuel = GetVehicleFuelLevel(PedCar)
				rpm = GetVehicleCurrentRpm(PedCar)
				rpmfuel = 0

				if rpm > 0.9 then
					rpmfuel = fuel - rpm / 0.8
					Citizen.Wait(1000)
				elseif rpm > 0.8 then
					rpmfuel = fuel - rpm / 1.1
					Citizen.Wait(1500)
				elseif rpm > 0.7 then
					rpmfuel = fuel - rpm / 2.2
					Citizen.Wait(2000)
				elseif rpm > 0.6 then
					rpmfuel = fuel - rpm / 4.1
					Citizen.Wait(3000)
				elseif rpm > 0.5 then
					rpmfuel = fuel - rpm / 5.7
					Citizen.Wait(4000)
				elseif rpm > 0.4 then
					rpmfuel = fuel - rpm / 6.4
					Citizen.Wait(5000)
				elseif rpm > 0.3 then
					rpmfuel = fuel - rpm / 6.9
					Citizen.Wait(6000)
				elseif rpm > 0.2 then
					rpmfuel = fuel - rpm / 7.3
					Citizen.Wait(8000)
				else
					rpmfuel = fuel - rpm / 7.5
					Citizen.Wait(15000)
				end

				VehFuel = SetVehicleFuelLevel(PedCar, rpmfuel)
		end
      end
	  Citizen.Wait(Config.FuelReloadTime)
	end
end)

---- CLEAR UI CACHE ----
Citizen.CreateThread(function() 
    while true do 
        collectgarbage() 
        Citizen.Wait(Config.ClearTime)
    end 
end)