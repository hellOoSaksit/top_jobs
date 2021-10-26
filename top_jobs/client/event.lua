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

RegisterNetEvent('top_jobs:TaskProcess')
AddEventHandler('top_jobs:TaskProcess', function(delay)
    if not IsPedInAnyVehicle(PlayerPed, false) and not IsEntityDead(PlayerPed) then
        TaskProcess(delay)
    end
end)

RegisterNetEvent('top_jobs:TaskRareAnimation')
AddEventHandler('top_jobs:TaskRareAnimation', function(name)
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