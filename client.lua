_g = {}
_g.TimeScaleList = {1, 2, 3, 5, 7, 10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100}
_g.SamplesList = {}
_g.TimeScale = 1
_g.Samples = 1

for i = 1, 30 do
    table.insert(_g.SamplesList, i)
end

-- NUI callback
RegisterNUICallback("callback", function(message, cb)
    if message.action == "hideNui" then
        SetPageStatus(false)
    else
        print("Unknown action: " .. message.action)
    end
    cb('ok')
end)

Citizen.CreateThread(function()
    WarMenu.CreateMenu('advanced-screenshots', 'Screenshots')
    while true do
        Citizen.Wait(0)
        if WarMenu.IsMenuOpened('advanced-screenshots') then
            if WarMenu.ComboBox('Shutter Speed', _g.TimeScaleList, _g.TimeScale, Config.TimeScale, function(currentIndex, selectedIndex)
                _g.TimeScale = currentIndex
                Config.TimeScale = selectedIndex
            end) then SendNotification("Config Saved") end
            if WarMenu.ComboBox('Samples', _g.SamplesList, _g.Samples, Config.Samples, function(currentIndex, selectedIndex)
                _g.Samples = currentIndex
                Config.Samples = selectedIndex
            end) then SendNotification("Config Saved") end
            WarMenu.Display()
        end
        if IsControlJustPressed(0, Config.Key) and not IsControlPressed(0, 36) then
            SetTimeScale(Config.TimeScale / 100)
            for i = 0, Config.Samples do
                data = TakeScreenshot()
                AddScreenshots(data, 1.0 - (i / Config.Samples))
            end
            SetTimeScale(1.0)
            SetPageStatus(true)
        elseif IsControlJustPressed(0, Config.Key) and IsControlPressed(0, 36) then
            WarMenu.OpenMenu('advanced-screenshots')
        end
    end
end)

function AddScreenshots(data, opacity)
    SendNUIMessage({
        action = "addScreenshot",
        data = {
            data = data,
            opacity = opacity
        }
    })
end

function TakeScreenshot()
    if _g.working then return end
    _g.working = true
    exports['screenshot-basic']:requestScreenshot(function(data)
        _g.screenshot = data
        _g.working = false
    end)
    while _g.working do
        Citizen.Wait(0)
    end
    return _g.screenshot
end

function SetPageStatus(status)
    _g.status = status
    SetNuiFocus(status, status)
    SendNUIMessage({action = "setPageStatus", data = {status = status}})
end

function IsPageOpened() return _g.status end

function SendNotification(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, false)
end
