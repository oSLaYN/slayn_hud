Config = {}
----------------------------------------------------------------------
Config.ReloadTime = 50 -- Interval To Reload The HUD and Get New Values
Config.TickTimeInto = 100 -- Tick Time Into Steps In GetStatus Function
Config.ClearTime = 30000 -- Interval To Clear The UI Cache
Config.FuelReloadTime = 5000 -- Interval To Reload Fuel Consume
------ WARNING: LOWERING THAT VALUES MAKE IMPACT IN PERFORMANCE ------

----------------------------------------------------------------------
Config.NeedsUpdate = 15000 -- Interval To Update The Player Needs
Config.ThirstQuantity = 1 -- Much Thirst Lower Into NeedsUpdate Timer
Config.HungerQuantity = 1 -- Much Hunger Lower Into NeedsUpdate Timer
Config.HealthQuantity = 5 -- Much Health Lower Into 0 Hunger Or Thirst

-------------------------------------------------------------------
Config.UseFramework = 'ESX' -- Change To Your Custom Framework - Options: ESX/QBCore/Custom (In There You Need To Choose Your Event Things)
Config.UseESXv2 = true -- Change If Not Using The Version 1.2 Of ES_EXTENDED
Config.CircularRadar = true -- Change The Radar Type, If You Want Circular, Just Stay True, If You Want Square, Insert False Instead True
Config.CustomType = true -- If You Want To Only Show Icons In HUD If Values Are Under X (See In Javasript The Values Of)
Config.EnableVehicleKeys = false -- Change This To True And Insert The Event Under To Work With It
Config.VehicleKeysEvent = "" -- Insert There The Event If You Up Inserted True
Config.EnableFuelScript = false -- Change This To True And Insert The Event Under To Work With It
Config.VehicleFuelEvent = "" -- Insert There The Event If You Up Inserted True
Config.SeatbeltKeyBind = "B" -- Keybind To Insert/Remove The Seatbelt Into Vehicle
Config.EnableSeatbeltSound = false -- Change This To True If You Use InteractSound
Config.MaxSpeed = 175 -- Set Maximum Velocity Without Seatbelt
Config.VoiceStates = {
    normal = 0,
    shout = 1,
    whisper = 2,
}
-------------------------------------------------------------------