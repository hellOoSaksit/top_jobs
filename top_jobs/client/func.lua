

DisplayHelpText = function(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

AddOnjToHand = function(Animation)
  local x,y,z = table.unpack(PlayerLoc)
  HandObject = CreateObject(GetHashKey(Animation.Prop), x, y, z+0.2,  true,  true, true)    
  if Animation.Prop == "prop_ld_fireaxe" then
    AttachEntityToEntity(HandObject, PlayerPed, GetPedBoneIndex(PlayerPed, 57005), 0.08, 0.0, 0.0, 270.0, 175.0, 20.0, true, true, false, true, 1, true)
  else
    AttachEntityToEntity(HandObject, PlayerPed, GetPedBoneIndex(PlayerPed, 57005), 0.08, 0.0, 0.0, 270.0, 175.0, 20.0, true, true, false, true, 1, true)
  end
end

ClearPropOnHand = function()
  if ModeFirstData ~= nil then
    local prop_name
    if ModeFirstData.Animation.Prop then
      prop_name = ModeFirstData.Animation.Prop
    else
      if ModeFirstData.Animation.Dict == "WORLD_HUMAN_CONST_DRILL" then
        prop_name = "prop_tool_jackham"
      end
    end

  local obj = GetClosestObjectOfType(PlayerLoc, 30.0, GetHashKey(prop_name), false, false, false)
  SetEntityAsMissionEntity(obj, true, true)
  DeleteObject(obj)
  end
end

DrawText3D = function(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    if onScreen then
        fontId = RegisterFontId('Mitr')
        SetTextScale(0.4, 0.4)
        SetTextFont(fontId)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

GenerateCoords = function(c)
	while true do
		Citizen.Wait(1)

		local CoordX, CoordY
    local width = ModeFirstData.PropSetting.Width

		math.randomseed(GetGameTimer())
		local modX = math.random(-width, width)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-width, width)

		CoordX = c.x + modX
		CoordY = c.y + modY

		local coordZ = GetCoordZ(CoordX, CoordY)
		local coord = vector3(CoordX, CoordY, coordZ)
    if ValidateCoord(coord) then
			return coord
		end
	end
end

GetCoordZ = function(x, y)

	for i = 1, 300 do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, tonumber(i..".0"))

		if foundGround then
			return z
		end
	end

	return 43.0
end

ValidateCoord = function(plantCoord)
  if ModeFirstData ~= nil then
    local data = ModeFirstData
    local entity

    if data.Obj ~= nil then
      entity = data.Obj
    else
      entity = data.Ped
    end
    
    local count = #entity

    if count > 0 then
      local validate = true

      for i=1, count do 
        if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(entity[i]), true) < 3 then
          validate = false
        end
      end

      if GetDistanceBetweenCoords(plantCoord, data.ObjPosition, false) > 50 then
        validate = false
      end

      return validate
    else
      return true
    end
  else
    return false
  end
end

playSound = function(data)
  if data.Name ~= "" then
      SendNUIMessage({
          action = "playSound",
          sound = data.Name,
          volume = data.Volume
      })
  end
end

TaskFirstMode = function(data)
  ModeFirstDataDoing = true
  if ModeFirstData == nil then
    ModeFirstData = {
      Status = "start",
      Text = data.Pickup.Text,
      MoneyTex = data.Pickup.Moneytex,
      Duration = data.Pickup.Duration,
      Animation = data.Pickup.Animation,
      Sound = data.Pickup.Sound,
      GetItems = data.Pickup.GetItems,
      TimeOut = data.Pickup.TimeOut,
      ObjPosition = data.Pickup.Position,
      Prop = data.Pickup.Prop,
      PropSetting = data.Pickup.PropSetting,
      EntityCount = 0,
      Obj = { },
      Ped = { },
      MoneyTax = data.Pickup.Moneytex,
    }
    ModeFirstData.RemoveObj = function()
      if ModeFirstData.Obj ~= nil then
        for i=1, #ModeFirstData.Obj do
          ESX.Game.DeleteObject(ModeFirstData.Obj[i])
        end
        ModeFirstData.Obj = nil
      end
      if ModeFirstData.Ped ~= nil then 
        for i=1, #ModeFirstData.Ped do
          DeleteEntity(ModeFirstData.Ped[i])
        end
        ModeFirstData.Ped = nil
      end
      ModeFirstClearCD = true
    end
    
    TaskFirstModeCheckSpawn()
    SendNUIMessage({
      action = "showUI",
      Mode = 1,
      Name = ModeFirstData.Text,
      Time = ModeFirstData.TimeOut
    })
    TaskFirstModeStart()
  end
end

TaskFirstModeCheckSpawn = function()
  Citizen.CreateThread(function()

    while ModeFirstData ~= nil and ModeFirstData.Status ~= "timeout" do
      Citizen.Wait(0)

      if (ModeFirstData.EntityCount < ModeFirstData.PropSetting.MaxSpawn) then

        if ModeFirstClearCD then
          ModeFirstClearCD = false
        else
          local delay = ModeFirstData.PropSetting.Delay
          if delay ~= nil then Citizen.Wait(delay) end
        end

        if ModeFirstData ~= nil then
        
        local pos = GenerateCoords(ModeFirstData.ObjPosition)
        if ModeFirstData.Prop.IsModel then
          local ModelHash = GetHashKey(ModeFirstData.Prop.Model)
          RequestModel(ModelHash)
          while not HasModelLoaded(ModelHash) do Wait(1) end

          local ped = CreatePed(4, ModeFirstData.Prop.Model, pos.x, pos.y, pos.z, tonumber(math.random( 1, 359)..".0") , false, true)

          local movement = ModeFirstData.PropSetting.Movement

          FreezeEntityPosition(ped, true)
          SetEntityInvincible(ped, true)

         if movement ~= nil and movement then
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, false)
            TaskWanderStandard(ped, true, true)
          end
          
          local Waepons = ModeFirstData.PropSetting.Waepons
          local WeaponsAmm = ModeFirstData.PropSetting.Amm
          if Waepons ~= nil and Waepons then
            RemoveWeaponFromPed(PlayerPedId(),GetHashKey(ModeFirstData.PropSetting.Waepons))
            SetPedAmmo(PlayerPedId(), GetHashKey(ModeFirstData.PropSetting.Waepons),0)
            GiveWeaponToPed(PlayerPedId(), GetHashKey(Waepons), 10, false, true)
          end

          local attack = ModeFirstData.PropSetting.Attack
          if attack ~= nil and attack then
            SetEntityInvincible(ped, false)
            local health = ModeFirstData.PropSetting.Health
            if health ~= nil then
              SetEntityHealth(ped, health)
            end
            TaskWanderInArea(ped,  pos.x, pos.y, pos.z, 4.0, 0, 2000)
            --TaskCombatPed(ped, PlayerPed, 0,16)
          end
          
          SetBlockingOfNonTemporaryEvents(ped, true)
          table.insert(ModeFirstData.Ped, ped)
          ModeFirstData.EntityCount = ModeFirstData.EntityCount  + 1
        else
          ESX.Game.SpawnLocalObject(ModeFirstData.Prop.Model, pos, function(obj)
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)

            table.insert(ModeFirstData.Obj, obj)
            ModeFirstData.EntityCount = ModeFirstData.EntityCount  + 1
          end)
        end
        end
      else
        break
      end

    end
  end)
end

TaskFirstModeStart = function()
  Citizen.CreateThread(function()

    local timeout = GetGameTimer() + ModeFirstData.TimeOut

    while ModeFirstData.Status ~= "timeout" do
      local time = timeout - GetGameTimer()
      --local timeformat = TimeFormat(time)
      if time < 1 then
        SendNUIMessage({
          action = "closeUI",
          Mode = 1,
        })
        if ModeFirstData.PropSetting.Waepons ~= nil then
          RemoveWeaponFromPed(PlayerPedId(),GetHashKey(ModeFirstData.PropSetting.Waepons))
          SetPedAmmo(PlayerPedId(), GetHashKey(ModeFirstData.PropSetting.Waepons),0)
      end
        ModeFirstData.RemoveObj()
        ModeFirstData.Status = "timeout"
        ModeFirstData = nil
        ModeFirstDataDoing = false
        break
      end
      --print(timeformat)
      Citizen.Wait(1000)
    end

    if ModeFirstData ~= nil then
      SendNUIMessage({
        action = "closeUI",
        Mode = 1,
      })
      if ModeFirstData.PropSetting.Waepons ~= nil then
        RemoveWeaponFromPed(PlayerPedId(),GetHashKey(ModeFirstData.PropSetting.Waepons))
        SetPedAmmo(PlayerPedId(), GetHashKey(ModeFirstData.PropSetting.Waepons),0)
      end
      ModeFirstData.RemoveObj()
      ModeFirstData.Status = "timeout"
      ModeFirstData = nil
      ModeFirstDataDoing = false
    end
  end)
end

TaskSecondMode = function(data)
  ModeSecondDataDoing = true
  if ModeSecondData == nil then
    print(EnableTex_2)
    ModeSecondData = {
      Status = "pickup",
      SendingPosition = data.Start.NPC.Position,
      Text = data.Pickup.Text,
      Duration = data.Pickup.Duration,
      Animation = data.Pickup.Animation,
      Sound = data.Pickup.Sound,
      GetItems = data.Pickup.GetItems,
      TimeOut = data.Pickup.TimeOut,
      MoneyTax = data.Pickup.Moneytex,
    }

      math.randomseed(GetGameTimer())
      ModeSecondData.ObjPosition = data.Pickup.Position[math.random(#data.Pickup.Position)]
      if data.Pickup.Prop.IsModel then
        local ModelHash = GetHashKey(data.Pickup.Prop.Model)

        RequestModel(ModelHash)
        while not HasModelLoaded(ModelHash) do Wait(1) end

        local ped = CreatePed(4, data.Pickup.Prop.Model, ModeSecondData.ObjPosition.x, ModeSecondData.ObjPosition.y, ModeSecondData.ObjPosition.z-1.0, math.random( 1.0, 359.0), false, true)

        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        ModeSecondData.Object = ped
        CreateBlip(ModeSecondData.Object, data.Pickup.Blip)
        SetNewWaypoint(ModeSecondData.ObjPosition.x, ModeSecondData.ObjPosition.y)
      else
        ESX.Game.SpawnLocalObject(data.Pickup.Prop.Model, ModeSecondData.ObjPosition, function(obj)
          PlaceObjectOnGroundProperly(obj)
          FreezeEntityPosition(obj, true)
          ModeSecondData.Object = obj
          CreateBlip(ModeSecondData.Object, data.Pickup.Blip)
          SetNewWaypoint(ModeSecondData.ObjPosition.x, ModeSecondData.ObjPosition.y)
        end)
      end

      ModeSecondData.RemoveObj = function()
        RemoveBlip(GetBlipFromEntity(ModeSecondData.Object))
        SetNewWaypoint(ModeSecondData.SendingPosition.x, ModeSecondData.SendingPosition.y)
        ESX.Game.DeleteObject(ModeSecondData.Object)
        DeleteEntity(ModeSecondData.Object)
        ModeSecondData.Object = nil
      end

    SendNUIMessage({
      action = "showUI",
      Mode = 2,
      Name = ModeSecondData.Text,
      Time = ModeSecondData.TimeOut,
      Status = Config.Text['status_pickup']:format(ModeSecondData.Text)
    })

    TaskSecondModeStart()

  end
end

TaskSecondModeStart = function() 

  Citizen.CreateThread(function()
    local timeout = GetGameTimer() + ModeSecondData.TimeOut

    while ModeSecondData.Status ~= "finish" and ModeSecondData.Status ~= "timeout" do
      local time = timeout - GetGameTimer()
      --local timeformat = TimeFormat(time)

      if time < 1 then
        ModeSecondDataDoing = false
        SendNUIMessage({
          action = "closeUI",
          Mode = 2,
        })
       
        ModeSecondData.RemoveObj()
        ModeSecondData.Status = "timeout"
        ModeSecondData = nil
        DeleteWaypoint()
        break
      end
      --print(timeformat)
      Citizen.Wait(1000)
    end

    if ModeSecondData ~= nil then
      ModeSecondDataDoing = false
      SendNUIMessage({
        action = "closeUI",
        Mode = 2,
      })
     
      ModeSecondData.RemoveObj()
      ModeSecondData.Status = "timeout"
      ModeSecondData = nil
      DeleteWaypoint()
    end
  end)
end


CreateBlip = function(obj, data)
  local blip = AddBlipForEntity(obj)
  SetBlipSprite(blip, data.Id)
  SetBlipColour(blip, data.Color)
  SetBlipScale(blip, data.Scale)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(data.Name)
  EndTextCommandSetBlipName(blip)
end

TaskProcess = function(delay)
  while TaskRareAnimation do Citizen.Wait(100) end
  if isDead then return end
  if CurrentActionPorcessData ~= nil then
    IsActionProcess = true
    if delay then
      KeyFix = true
      Citizen.CreateThread(function()
        CloseKey()
      end)
      Citizen.Wait(1000)
      KeyFix = false
    end
    local data = CurrentActionPorcessData.ModeSetting.Process
    playSound(data.Sound)
    TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = data.Duration,
        label = Config.Text['cancle_key'],
        useWhileDead = true,
        canCancel = true,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = data.Animation.Dict,
            anim = data.Animation.Name,
        }
    }, function(s)
      if not s then
          TriggerServerEvent('uilt_jobs:processItems', data.RemoveItems, data.GetItems, data.AutoProcess)
      end
        IsActionProcess = false
    end)
  else
    IsActionProcess = false
  end
end

CloseKey = function()
  while KeyFix do
    if KeyFix then
      DisableAllControlActions(0)
      EnableControlAction(0, 1, true) -- Disable pan
      EnableControlAction(0, 2, true) -- Disable tilt
    end
    Citizen.Wait(5)
  end
end

CheckEntityPos = function(e, pos)
  local dist = #(GetEntityCoords(e) - pos)
  if dist < 20.0 then
    return true
  else
    return false
  end
end

CombatCheck = function(entity)

  if not IsCombatCheck then
    IsCombatCheck = true 
    Citizen.Wait(50)
    IsCombatCheck = false 

    return IsPedInCombat(entity, PlayerPed)
  end
end