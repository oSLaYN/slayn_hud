if Config.UseFramework == "ESX" then
    ESX = nil
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    ESX.RegisterServerCallback('slayn_hud:GetStatus', function(source, cb, vthirst, vhunger, vstress)
        local source = source
        if Config.UseESXv2 == true then
            local xPlayer = ESX.GetIdentifier(source)
            MySQL.query('SELECT * FROM users WHERE identifier=@user', {["@user"]=xPlayer}, function(resultf)
                if resultf ~= nil then
                    for _, v in pairs(resultf) do
                        vthirst = v.thirst
                        vhunger = v.hunger
                        vstress = v.stress
                    end
                    cb(vthirst, vhunger, vstress)
                end
            end)
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            MySQL.query('SELECT * FROM users WHERE identifier=@user', {["@user"]=xPlayer.identifier}, function(resultf)
                if resultf ~= nil then
                    for _, v in pairs(resultf) do
                        vthirst = v.thirst
                        vhunger = v.hunger
                        vstress = v.stress
                    end
                    cb(vthirst, vhunger, vstress)
                end
            end)
        end
    end)

    ESX.RegisterServerCallback('slayn_hud:UpdateStatus', function(source, cb, vthirst, vhunger, vstress)
        local source = source
        local xPlayer = ESX.GetIdentifier(source)
        if Config.UseESXv2 == true then
            local xPlayer = ESX.GetIdentifier(source)
            MySQL.query('SELECT * FROM users WHERE identifier=@user', {["@user"]=xPlayer}, function(resultf)
                if resultf ~= nil then
                    local resultt = MySQL.update('UPDATE users SET thirst=@thirst WHERE identifier=@user', {["@user"]=xPlayer, ["@thirst"]=vthirst})
                    local resulth = MySQL.update('UPDATE users SET hunger=@hunger WHERE identifier=@user', {["@user"]=xPlayer, ["@hunger"]=vhunger})
                    local results = MySQL.update('UPDATE users SET stress=@stress WHERE identifier=@user', {["@user"]=xPlayer, ["@stress"]=vstress})
                    cb(vthirst, vhunger, vstress)
                end
            end)
        else
            local xPlayer = ESX.GetPlayerFromId(source)
            MySQL.query('SELECT * FROM users WHERE identifier=@user', {["@user"]=xPlayer.identifier}, function(resultf)
                if resultf ~= nil then
                    local resultt = MySQL.update('UPDATE users SET thirst=@thirst WHERE identifier=@user', {["@user"]=xPlayer.identifier, ["@thirst"]=vthirst})
                    local resulth = MySQL.update('UPDATE users SET hunger=@hunger WHERE identifier=@user', {["@user"]=xPlayer.identifier, ["@hunger"]=vhunger})
                    local results = MySQL.update('UPDATE users SET stress=@stress WHERE identifier=@user', {["@user"]=xPlayer.identifier, ["@stress"]=vstress})
                    cb(vthirst, vhunger, vstress)
                end
            end)
        end
    end)
elseif Config.UseFramework == "QBCore" then
    -- DO NOTHING RIGHT NOW
elseif Config.UseFramework == "Custom" then
    -- INSERT YOUR OWN FRAMEWORK TYPE
end