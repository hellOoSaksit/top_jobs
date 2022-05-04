AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
   
    end
 end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        for i = 1, #CacheNPC do 
            DeleteEntity(CacheNPC[i])
        end

        if ModeFirstData ~= nil then
            if ModeFirstData.Obj ~= nil then
                for i=1, #ModeFirstData.Obj do
                    DeleteObject(ModeFirstData.Obj[i])
                end
            end

            if ModeFirstData.Ped ~= nil then
                for i=1, #ModeFirstData.Ped do
                    DeleteEntity(ModeFirstData.Ped[i])
                end
            end
        end

        if ModeSecondData ~= nil then
            DeleteObject(ModeSecondData.Object)
            DeleteEntity(ModeSecondData.Object)
        end
    end
end)

RegisterNetEvent('uilt_jobs:TaskProcess')
AddEventHandler('uilt_jobs:TaskProcess', function(delay)
    if not IsPedInAnyVehicle(PlayerPed, false) and not IsEntityDead(PlayerPed) then
        TaskProcess(delay)
    end
end)

RegisterNetEvent('uilt_jobs:TaskRareAnimation')
AddEventHandler('uilt_jobs:TaskRareAnimation', function(name)
    if isDead then return end
    while TaskRareAnimation do Citizen.Wait(100) end

    if not TaskRareAnimation then
        TaskRareAnimation = true

        local config = Config.RareItemAlert[name]

        playSound(config.Sound)
        ESX.Streaming.RequestAnimDict(config.Animation.Dict, function()
            TaskPlayAnim(PlayerPed,config.Animation.Dict, config.Animation.Name, 8.0, -8, -1, 1, 0, 0, 0, 0)
        end)
        Citizen.Wait(2000)
        ClearPedTasks(PlayerPed)
        TaskRareAnimation = false
    end

end)

--Update 29/4/2565
RegisterNetEvent("TaskSecondMode:Check")
AddEventHandler("TaskSecondMode:Check", function(data)
    local CurrentActionData = Config.Jobs[CurrentActionJob]
    local CheckMoneyTex_2 = data
    if CheckMoneyTex_2 then
      EnableTex_2 = true
      print('Func:1')
      TaskSecondMode(CurrentActionData.ModeSetting)
    else
      EnableTex_2 = false
      print('Func:2 | No Money')
    end
end)

RegisterNetEvent("TaskFristMode:Check")
AddEventHandler("TaskFristMode:Check", function(data)
    local CurrentActionData = Config.Jobs[CurrentActionJob]
    local CheckMoneyTex_1 = data
    if CheckMoneyTex_1 then
      EnableTex_1 = true
      print('Func:1')
      TaskFirstMode(CurrentActionData.ModeSetting)
    else
      EnableTex_1 = false
      print('Func:2 | No Money')
    end
end)