-- Create NPC
Citizen.CreateThread(function()
    Citizen.Wait(500)
    local config = Config.Jobs

    RequestAnimDict("mini@strip_club@idles@bouncer@base")
      while not HasAnimDictLoaded("mini@strip_club@idles@bouncer@base") do
        Wait(1)
    end

	for k, v in pairs(config) do
        local npc = v.ModeSetting.Start.NPC
        if npc then
            local ModelHash = GetHashKey(npc.Model)

            RequestModel(ModelHash)
            while not HasModelLoaded(ModelHash) do Wait(1) end
            
            local NpcNum = #CacheNPC + 1
            CacheNPC[NpcNum] = CreatePed(4, npc.Model, npc.Position.x, npc.Position.y, npc.Position.z-1.0, npc.Head, false, true)
    
            FreezeEntityPosition(CacheNPC[NpcNum], true)
            SetEntityInvincible(CacheNPC[NpcNum], true)
            SetBlockingOfNonTemporaryEvents(CacheNPC[NpcNum], true)
            TaskPlayAnim(CacheNPC[NpcNum],"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
            -- SetIgnoreLowPriorityShockingEvents(CacheNPC[NpcNum], 294)
        end
           
        if v.ModeSetting.Process ~= nil then
            local npc2 = v.ModeSetting.Process.NPC
            if npc2 then
                local ModelHash = GetHashKey(npc2.Model)

                RequestModel(ModelHash)
                while not HasModelLoaded(ModelHash) do Wait(1) end
                
                local NpcNum = #CacheNPC + 1
                CacheNPC[NpcNum] = CreatePed(4, npc2.Model, npc2.Position.x, npc2.Position.y, npc2.Position.z-1.0, npc2.Head, false, true)
        
                FreezeEntityPosition(CacheNPC[NpcNum], true)
                SetEntityInvincible(CacheNPC[NpcNum], true)
                SetBlockingOfNonTemporaryEvents(CacheNPC[NpcNum], true)
                TaskPlayAnim(CacheNPC[NpcNum],"mini@strip_club@idles@bouncer@base","base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
            end
        end
    end
end)

Citizen.CreateThread(function()

    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
        RegisterFontFile('Mitr')
    end)

    Citizen.Wait(10)
    
    Citizen.CreateThread(function()
        while true do 
            PlayerPed = PlayerPedId()
            Citizen.Wait(1000)
        end
    end)

    Citizen.Wait(10)

    Citizen.CreateThread(function()
        while true do 
            PlayerLoc = GetEntityCoords(PlayerPed)
            Citizen.Wait(250)
        end
    end)

    Citizen.Wait(10)

    Citizen.CreateThread(function()
        while true do 
            isDead = IsEntityDead(PlayerPed)
            -- print(tostring(isDead))
            Citizen.Wait(1000)
        end
    end)

    Citizen.Wait(10)

    -- Blip
    Citizen.CreateThread(function()
        local config = Config.Jobs
        for _, info in pairs(config) do

            local pos = info.ModeSetting.Start.NPC.Position
            local blip = info.ModeSetting.Start.Blip
            info.blip = AddBlipForCoord(pos.x, pos.y, pos.z)
            SetBlipSprite(info.blip, blip.Id)
            SetBlipDisplay(info.blip, 4)
            SetBlipScale(info.blip, blip.Scale)
            SetBlipColour(info.blip, blip.Color)
            SetBlipAsShortRange(info.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString('<font face="Mitr">'..blip.Name..'')
            EndTextCommandSetBlipName(info.blip)

            if info.ModeSetting.Process ~= nil then
                local pos2 = info.ModeSetting.Process.NPC.Position
                local blip = info.ModeSetting.Process.Blip
                info.blip = AddBlipForCoord(pos2.x, pos2.y, pos2.z)
                SetBlipSprite(info.blip, blip.Id)
                SetBlipDisplay(info.blip, 4)
                SetBlipScale(info.blip, blip.Scale)
                SetBlipColour(info.blip, blip.Color)
                SetBlipAsShortRange(info.blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString('<font face="Mitr">'..blip.Name..'')
                EndTextCommandSetBlipName(info.blip)
            end
        end
    end)

    Citizen.Wait(10)

    Citizen.CreateThread(function()
        local config    = Config.Jobs
        local setting   = Config.Setting

        while true do
            Citizen.Wait(5)
            if not IsActionProcess then
                local isInMarker, hasExited, letSleep = false, false, true
                local currentProcess, currentData
                
                for k,v in pairs(config) do
                    if v.ModeSetting.Process ~= nil then
                        local npc = v.ModeSetting.Process.NPC
                        local dist = #(PlayerLoc - npc.Position)
                        
                        if dist < setting.ShowTextDistance then
        
                            local pos = npc.Position
                            DrawText3D(pos.x, pos.y, pos.z + 1.3, Config.Text['press_to_process']:format(npc.Text))
                            letSleep = false
            
                            if dist < setting.ActionDistance then
                                isInMarker, currentProcess, currentData = true, k, v
                            end
                        end
                    end
                end
        
                if isInMarker and not HasAlreadyEnteredMarker2 or (isInMarker and ( LastProcess ~= currentProcess)) then
                    if LastProcess and (LastProcess ~= currentProcess) then
                        CurrentActionPorcess = nil
                        CurrentActionPorcessData = nil
                        hasExited = true
                    end
        
                    HasAlreadyEnteredMarker2 = true
                    LastProcess             = currentProcess
        
                    CurrentActionPorcess    = currentProcess
                    CurrentActionPorcessData   = currentData
                end
        
                if not hasExited and not isInMarker and HasAlreadyEnteredMarker2 then
                    HasAlreadyEnteredMarker2 = false
                    CurrentActionPorcess        = nil
                    CurrentActionPorcessData       = nil
                end
        
                if letSleep then
                    Citizen.Wait(500)
                end
            end
        end
    end)

    Citizen.Wait(10)

    -- Check Distance Player Nearby NPC
    Citizen.CreateThread(function()

        local config    = Config.Jobs
        local setting   = Config.Setting

        while true do
            Citizen.Wait(5)
          
            local isInMarker, hasExited, letSleep = false, false, true
            local currentJob, currentData
            
            for k,v in pairs(config) do
                if v.Mode == 2 then
                    if ModeSecondDataDoing then
                        break
                    end
                end

                local npc = v.ModeSetting.Start.NPC
                local dist = #(PlayerLoc - npc.Position)
                
                if dist < setting.ShowTextDistance then

                    local pos = npc.Position
                    DrawText3D(pos.x, pos.y, pos.z + 1.3, (Config.Text['press_to_start']):format(npc.Text))
                    letSleep = false
    
                    if dist < setting.ActionDistance then
                        isInMarker, currentJob, currentData = true, k, v
                    end
                end
    
            end
    
            if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and ( LastJob ~= currentJob)) then
                if LastJob and (LastJob ~= currentJob) then
                    CurrentActionJob = nil
                    CurrentActionData = nil
                    hasExited = true
                end
    
                HasAlreadyEnteredMarker = true
                LastJob             = currentJob
    
                CurrentActionJob    = currentJob
                CurrentActionData   = currentData
            end
    
            if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
                CurrentActionJob        = nil
                --CurrentActionData       = nil
            end
    
            if letSleep then
                Citizen.Wait(500)
            end
        end
    end)

    Citizen.Wait(10)


    -- Control Action Pickup
    Citizen.CreateThread(function()
        while true do 
            if CurrentActionJob then
                if IsControlJustReleased(0, 38) then
                    if CurrentActionJob ~= nil then
                        -- if CurrentActionData == nil then
                        --     CurrentActionData = Config.Jobs[CurrentActionJob]
                        -- end
                        -- หลักกด E เริ่มงาน
                        while CurrentActionData == nil do Citizen.Wait(5) CurrentActionData = Config.Jobs[CurrentActionJob] end

                        if CurrentActionData.Mode == 1 then
                            if ModeFirstDataDoing then
                                ModeFirstData.Status = "timeout"
                                while ModeFirstDataDoing do Citizen.Wait(250) end
                            end
                            if CurrentActionData == nil then
                                CurrentActionData = Config.Jobs[CurrentActionJob]
                            end
                            if Config.MoneyTaxPay then 
                                playSound(CurrentActionData.ModeSetting.Start.Sound)
                                TriggerServerEvent('uilt_jobs:MoneyPayTaskFristMone', CurrentActionData.ModeSetting.Pickup.Moneytex) 
                            else
                                playSound(CurrentActionData.ModeSetting.Start.Sound)
                                TaskFirstMode(CurrentActionData.ModeSetting)
                            end
                            -- playSound(CurrentActionData.ModeSetting.Start.Sound)
                            -- TaskFirstMode(CurrentActionData.ModeSetting)
                            Citizen.Wait(2000)
                        elseif CurrentActionData.Mode == 2 and not ModeSecondDataDoing then
                            if Config.MoneyTaxPay then 
                                TriggerServerEvent('uilt_jobs:MoneyPayTaskSecondeMone', CurrentActionData.ModeSetting.Pickup.Moneytex) 
                                --   TaskSecondMode(CurrentActionData.ModeSetting) 29/4/2565
                            else
                                TaskSecondMode(CurrentActionData.ModeSetting)
                            end
                            Citizen.Wait(2000)
                        end
                    else
                        Citizen.Wait(1000)
                    end
                end
            else
                Citizen.Wait(500)
            end
            Citizen.Wait(5)
        end
    end)

    Citizen.Wait(10)

    -- Control Action Process
    Citizen.CreateThread(function()
        while true do 
            if CurrentActionPorcess then
                if IsControlJustReleased(0, 38) and CurrentActionPorcessData ~= nil and not IsActionProcess then
                    TriggerEvent('uilt_jobs:TaskProcess', false)
                end
            else
                Citizen.Wait(500)
            end
            Citizen.Wait(5)
        end
    end)

    Citizen.Wait(10)

    -- Mode 1 Action
    Citizen.CreateThread(function()
        local setting = Config.Setting
        local IsAction = false
        local killin = false
        while true do
            --local data = ModeFirstData
            if ModeFirstData ~= nil then
                if ModeFirstData.Status == "start" then
                    local entity
                    if ModeFirstData.Obj ~= nil then
                    if #ModeFirstData.Obj == 0 then
                        entity = ModeFirstData.Ped 
                    else
                        entity = ModeFirstData.Obj 
                    end
                    local count = #entity
                    local entitycoord
                    local nearbyObject, nearbyID

                    for i=1, count do 
                        entitycoord = GetEntityCoords(entity[i])
                        local dist = #(PlayerLoc - entitycoord)

                        -- if ModeFirstData.Prop.IsModel then
                        --     if not IsCombatCheck and not IsEntityDead(entity[i]) then
                        --         local inCombat = CombatCheck(entity[i])
                        --         if dist < 8.0 then
                        --             if not inCombat then
                        --                 TaskCombatPed(entity[i], PlayerPed, 0,16)
                        --             end
                        --         else
                        --             if inCombat then
                        --                 TaskWanderInArea(entity[i], entitycoord.x, entitycoord.y, entitycoord.z, 4.0, 0, 2000)
                        --             end
                        --         end
                        --     end
                        -- end

                        if dist < setting.ActionDistance then
                            nearbyObject, nearbyID = entity[i], i
                            break
                        end
                        
                    end

                    if ModeFirstData.PropSetting.Attack then
                        killin = IsEntityDead(nearbyObject)
                    else
                        killin = true
                    end

                    if nearbyObject and IsPedOnFoot(PlayerPed) and killin then
                        
                        if not IsAction then
                            DrawText3D(entitycoord.x, entitycoord.y, entitycoord.z + 1.2, (Config.Text['press_to_pickup']):format(ModeFirstData.Text))
                        end

                        if IsControlJustReleased(0, 38) and not IsAction then
                            IsAction = true
                            playSound(ModeFirstData.Sound)
                            FreezeEntityPosition(nearbyObject, true)

                            if ModeFirstData.Animation.Name == false then
                                TaskStartScenarioInPlace(PlayerPed, ModeFirstData.Animation.Dict, 0, false)
                            else
                                ESX.Streaming.RequestAnimDict(ModeFirstData.Animation.Dict, function()
									TaskPlayAnim(PlayerPed, ModeFirstData.Animation.Dict, ModeFirstData.Animation.Name, 8.0, -8, -1, 49, 0, 0, 0, 0)
								end)
                            end

                            if ModeFirstData.Animation.Prop then
                                AddOnjToHand(ModeFirstData.Animation)
                            end

                            TriggerEvent("mythic_progbar:client:progress", {
                                name = "unique_action_name",
                                duration = ModeFirstData.Duration,
                                label = "",
                                useWhileDead = false,
                                canCancel = false,
                                controlDisables = {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                },
                                -- animation = {
                                --     animDict = ModeFirstData.Animation.Dict,
                                --     anim = ModeFirstData.Animation.Name,
                                -- }
                            }, function()
                              
                                    if ModeFirstData ~= nil then
                                        if ModeFirstData.Prop.IsModel then
                                            if CheckEntityPos(nearbyObject,ModeFirstData.ObjPosition) then
                                                TriggerServerEvent('uilt_jobs:addItems', ModeFirstData.GetItems)
                                            end
                                        else
                                            TriggerServerEvent('uilt_jobs:addItems', ModeFirstData.GetItems)
                                        end
                                        ESX.Game.DeleteObject(nearbyObject)
                                        DeleteEntity(nearbyObject)
                                        table.remove(entity, nearbyID)
                                        ModeFirstData.EntityCount = ModeFirstData.EntityCount - 1
                                        TaskFirstModeCheckSpawn()
                                    end
                              
                                ClearPedTasksImmediately(PlayerPed)
                                ClearPropOnHand()
                                IsAction = false
                                killin = false
                            end)

                            --ClearPedTasks(PlayerPed)
                        end
                    end
                    end
                end
            else
                Citizen.Wait(500)
            end
            Citizen.Wait(5)
        end
    end)

    -- Mode 2 Action
    Citizen.CreateThread(function()
        local setting = Config.Setting
        local IsAction = false
        local updateStatus = false

        while true do
            --local data = ModeSecondData
            if ModeSecondData ~= nil then
                if ModeSecondData.Status == "pickup" then
                    local pos = ModeSecondData.ObjPosition
                    local dist = #(PlayerLoc - pos)
                    if dist < setting.ShowTextDistance then
                        if not IsAction then
                            DrawText3D(pos.x, pos.y, pos.z + 0.7, (Config.Text['press_to_pickup']):format(ModeSecondData.Text))
                        end
                        if dist < setting.ActionDistance then
                            if IsControlJustReleased(0, 38) and not IsAction then
                                IsAction = true
                                playSound(ModeSecondData.Sound)
                                TriggerEvent("mythic_progbar:client:progress", {
                                    name = "unique_action_name",
                                    duration = ModeSecondData.Duration,
                                    label = "",
                                    useWhileDead = false,
                                    canCancel = false,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                    animation = {
                                        animDict = ModeSecondData.Animation.Dict,
                                        anim = ModeSecondData.Animation.Name,
                                    }
                                }, function()
                             
                                        if ModeSecondData ~= nil then
                                            ModeSecondData.RemoveObj()
                                            ModeSecondData.Status = "sending"
                                        end
                                 
                                    IsAction = false
                                end)
                                ClearPedTasks(PlayerPed)
                            end
                        end
                    end
                elseif ModeSecondData.Status == "sending" then
                    if not updateStatus then
                        updateStatus = true
                        SendNUIMessage({
                            action = "statusUpdate",
                            Mode = 2,
                            Status = Config.Text['status_sending']:format(ModeSecondData.Text)
                        })
                    end
                    local pos = ModeSecondData.SendingPosition
                    local dist = #(PlayerLoc - pos)
                    if dist < setting.ShowTextDistance then
                        if not IsAction then
                            DrawText3D(pos.x, pos.y, pos.z + 1.3, (Config.Text['press_to_sending']):format(ModeSecondData.Text))
                        end
                        if dist < setting.ActionDistance then
                            if IsControlJustReleased(0, 38) and not IsAction then
                                IsAction = true
                                playSound(ModeSecondData.Sound)
                                TriggerEvent("mythic_progbar:client:progress", {
                                    name = "unique_action_name",
                                    duration = ModeSecondData.Duration/4,
                                    label = "",
                                    useWhileDead = false,
                                    canCancel = false,
                                    controlDisables = {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    },
                                    animation = {
                                        animDict = ModeSecondData.Animation.Dict,
                                        anim = ModeSecondData.Animation.Name,
                                    }
                                }, function()
                                    TriggerServerEvent('uilt_jobs:addItems', ModeSecondData.GetItems)
                                    ModeSecondData.Status = "finish"
                                  
                                    IsAction = false
                                end)
                                ClearPedTasks(PlayerPed)
                            end
                        end
                    end
                elseif ModeSecondData.Status == "finish" or ModeSecondData.Status == "timeout" then
                   -- ModeSecondData = nil
                    ModeSecondDataDoing = false
                end
            else
                Citizen.Wait(500)
            end
            Citizen.Wait(5)
        end
    end)

    Citizen.CreateThread(function()
        local s = Config.Setting.AreaDistance

        while true do
            if ModeFirstData ~= nil then
                local dist = #(PlayerLoc - ModeFirstData.ObjPosition)
                
                if dist > s then
                    if ModeFirstData.PropSetting.Waepons ~= nil then
                        RemoveWeaponFromPed(PlayerPedId(),GetHashKey(ModeFirstData.PropSetting.Waepons))
                        SetPedAmmo(PlayerPedId(), GetHashKey(ModeFirstData.PropSetting.Waepons),0)
                    end
                    ModeFirstData.Status = "timeout"
                    ModeFirstData.RemoveObj()
                else
                    if ModeFirstData.PropSetting.Waepons ~= nil then
                        N_0x4757f00bc6323cfe(GetHashKey(ModeFirstData.PropSetting.Waepons), 0.1) 
                        --print(ModeFirstData.PropSetting.Waepons)
                    end
                end
            end
            Citizen.Wait(0)
        end
    end)
end)


