ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
      
    end
 end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        
    end
end)

AddEventHandler('esx:playerLoaded', function (playerId)
end)

AddEventHandler('playerDropped', function (reason)
end)

RegisterServerEvent('uilt_jobs:processItems')
AddEventHandler('uilt_jobs:processItems', function(data, data2, auto)
    local xPlayer = ESX.GetPlayerFromId(source)
    local removeList = data
    local itemList = CreateRandomItems(data2)

    for i=1, #removeList do 
        local name = removeList[i].ItemName
        local count = math.random(removeList[i].ItemCount[1], removeList[i].ItemCount[2])

        local xItem = xPlayer.getInventoryItem(name)
        if xItem.count < count then
            Notify.Server(Config.Text['not_enough']:format(xItem.label), 'error', xPlayer.source)
            return
        else
            removeList[i].ItemCount = count
        end
    end

    for i=1, #itemList do 
        local name = itemList[i].ItemName
        local count = math.random(itemList[i].ItemCount[1], itemList[i].ItemCount[2])

        local xItem = xPlayer.getInventoryItem(name)
        if Config.ESXOld then 
        if xItem.limit ~= 0 then
            if xItem.count < xItem.limit then
                if (xItem.count + count) <= xItem.limit then
                    itemList[i].ItemCount = count
                else
                    itemList[i].ItemCount = xItem.limit
                end
            else
                Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                return
            end
        else

                            --------------------------------------------------------------------------------------------
                            --กระเป๋า NC แก้ไข
                            local limit = exports.nc_inventory:GetItemLimit(name) --NC
                            local weight = exports.nc_inventory:GetItemWeight(name) -- น้ำหนักไอเทม
                            local _weight, _maxWeight = exports.nc_inventory:GetInventoryWeight(xPlayer.source)
                            local limit_check = nil
                            local _weightitem = 0
                            if limit == -1 then
                                limit_check = true
                                _weightitem = _weight + weight
                                print(_weightitem ,weight ,_maxWeight ,_weight)
                            else
                                limit_check = false
                            end
                            --------------------------------------------------------------------------------------------
                            if limit_check then
                                if limit_check and _weightitem <= _maxWeight  then
                                    if xPlayer.canCarryItem(name, count) then
                                        xPlayer.addInventoryItem(name, count)
                                        exports.nc_discordlogs:Discord({
                                            webhook = '|Bot_uilt_jobs_additem|',			-- ใส่ชื่อ webhook ที่ต้องการใน Config.Webhooks
                                            xPlayer = xPlayer,					-- ในฝั่ง Server ต้องใส่ xPlayer ทุกครั้ง (ตัวอย่างการประกาศค่า xPlayer: local xPlayer = ESX.GetPlayerFromId(playerId))
                                            title = 'ได้รับไอเทม',					-- หัวเรื่องที่ต้องการแสดงใน discord
                                            message = 'ผู้เล่น'	.. xPlayer.name .. ' ได้รับ ' .. xItem.label .. ' จำนวน ' .. ESX.Math.GroupDigits(count) .. ' เข้าตัว',				-- message คือ title ที่จะนำหน้าด้วยชื่อผู้เล่น (หากใช้งาน title และ message พร้อมกัน จะแสดงค่าเป็น title แทน)
                                            public = false,			-- แสดง Log สาธารณะ (true: ไม่แสดงข้อมูลผู้เล่น | false|nil: แสดงข้อมูลผู้เล่น) | Default: nil
                                        })
                                    end
                                else
                                    Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                                end
                            --------------------------------------------------------------------------------------------
                            elseif xItem.count <= limit then -- NC
                                xPlayer.addInventoryItem(name, count)
                                exports.nc_discordlogs:Discord({
                                    webhook = '|Bot_uilt_jobs_additem|',			-- ใส่ชื่อ webhook ที่ต้องการใน Config.Webhooks
                                    xPlayer = xPlayer,					-- ในฝั่ง Server ต้องใส่ xPlayer ทุกครั้ง (ตัวอย่างการประกาศค่า xPlayer: local xPlayer = ESX.GetPlayerFromId(playerId))
                                    title = 'ได้รับไอเทม',					-- หัวเรื่องที่ต้องการแสดงใน discord
                                    message = 'ผู้เล่น'	.. xPlayer.name .. ' ได้รับ ' .. xItem.label .. ' จำนวน ' .. ESX.Math.GroupDigits(count) .. ' เข้าตัว',				-- message คือ title ที่จะนำหน้าด้วยชื่อผู้เล่น (หากใช้งาน title และ message พร้อมกัน จะแสดงค่าเป็น title แทน)
                                    public = false,			-- แสดง Log สาธารณะ (true: ไม่แสดงข้อมูลผู้เล่น | false|nil: แสดงข้อมูลผู้เล่น) | Default: nil
                                })
                            else
                                Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                            end
                            --------------------------------------------------------------------------------------------
        end

        else
            itemList[i].ItemCount = count
        end
    end

    for i=1, #removeList do 
        local name = removeList[i].ItemName
        local count = removeList[i].ItemCount

        xPlayer.removeInventoryItem(name, count)
    end

    for i=1, #itemList do 
        local name = itemList[i].ItemName
        local count = itemList[i].ItemCount

        local xItem = xPlayer.getInventoryItem(name)

        if Config.ESXOld then
            if xItem.limit ~= 0 then
                if xItem.count < xItem.limit then
                    if (xItem.count + count) <= xItem.limit then
                        xPlayer.addInventoryItem(name, count)
                        ChechRareItem(xPlayer.source, xItem.name)
                    else
                        xPlayer.setInventoryItem(name, xItem.limit)
                    ChechRareItem(xPlayer.source,xItem.name)
                    end
                else
                    Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                    return
                end
            else
                -- xPlayer.addInventoryItem(name, count)
                -- ChechRareItem(xPlayer.source,xItem.name)
            end
        else
                 --------------------------------------------------------------------------------------------
                            --กระเป๋า NC แก้ไข
                            local limit = exports.nc_inventory:GetItemLimit(name) --NC
                            local weight = exports.nc_inventory:GetItemWeight(name) -- น้ำหนักไอเทม
                            local _weight, _maxWeight = exports.nc_inventory:GetInventoryWeight(xPlayer.source)
                            local limit_check = nil
                            local _weightitem = 0
                            if limit == -1 then
                                limit_check = true
                                _weightitem = _weight + weight
                                print(_weightitem ,weight ,_maxWeight ,_weight)
                            else
                                limit_check = false
                            end
                            --------------------------------------------------------------------------------------------
                            if limit_check then
                                if limit_check and _weightitem <= _maxWeight  then
                                    if xPlayer.canCarryItem(name, count) then
                                        xPlayer.addInventoryItem(name, count)
                                        exports.nc_discordlogs:Discord({
                                            webhook = '|Bot_uilt_jobs_additem|',			-- ใส่ชื่อ webhook ที่ต้องการใน Config.Webhooks
                                            xPlayer = xPlayer,					-- ในฝั่ง Server ต้องใส่ xPlayer ทุกครั้ง (ตัวอย่างการประกาศค่า xPlayer: local xPlayer = ESX.GetPlayerFromId(playerId))
                                            title = 'ได้รับไอเทม',					-- หัวเรื่องที่ต้องการแสดงใน discord
                                            message = 'ผู้เล่น'	.. xPlayer.name .. ' ได้รับ ' .. xItem.label .. ' จำนวน ' .. ESX.Math.GroupDigits(count) .. ' เข้าตัว',				-- message คือ title ที่จะนำหน้าด้วยชื่อผู้เล่น (หากใช้งาน title และ message พร้อมกัน จะแสดงค่าเป็น title แทน)
                                            public = false,			-- แสดง Log สาธารณะ (true: ไม่แสดงข้อมูลผู้เล่น | false|nil: แสดงข้อมูลผู้เล่น) | Default: nil
                                        })
                                    end
                                else
                                    Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                                    auto = false
                                end
                            --------------------------------------------------------------------------------------------
                            elseif xItem.count <= limit then -- NC
                                xPlayer.addInventoryItem(name, count)
                                exports.nc_discordlogs:Discord({
                                    webhook = '|Bot_uilt_jobs_additem|',			-- ใส่ชื่อ webhook ที่ต้องการใน Config.Webhooks
                                    xPlayer = xPlayer,					-- ในฝั่ง Server ต้องใส่ xPlayer ทุกครั้ง (ตัวอย่างการประกาศค่า xPlayer: local xPlayer = ESX.GetPlayerFromId(playerId))
                                    title = 'ได้รับไอเทม',					-- หัวเรื่องที่ต้องการแสดงใน discord
                                    message = 'ผู้เล่น'	.. xPlayer.name .. ' ได้รับ ' .. xItem.label .. ' จำนวน ' .. ESX.Math.GroupDigits(count) .. ' เข้าตัว',				-- message คือ title ที่จะนำหน้าด้วยชื่อผู้เล่น (หากใช้งาน title และ message พร้อมกัน จะแสดงค่าเป็น title แทน)
                                    public = false,			-- แสดง Log สาธารณะ (true: ไม่แสดงข้อมูลผู้เล่น | false|nil: แสดงข้อมูลผู้เล่น) | Default: nil
                                })
                            else
                                Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                                auto = false
                            end
                            --------------------------------------------------------------------------------------------
        end
    end

    if auto then
        TriggerClientEvent('uilt_jobs:TaskProcess', xPlayer.source, true)
    end
end)

RegisterServerEvent('uilt_jobs:addItems')
AddEventHandler('uilt_jobs:addItems', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemList = CreateRandomItems(data)

    local listCount = #itemList
    for i=1, listCount do 
        local name = itemList[i].ItemName
        local count = math.random(itemList[i].ItemCount[1], itemList[i].ItemCount[2])

        local xItem = xPlayer.getInventoryItem(name)

        if Config.ESXOld then
            if xItem.limit ~= 0 then
                if xItem.count < xItem.limit then
                    if (xItem.count + count) <= xItem.limit then
                        xPlayer.addInventoryItem(name, count)
                    else
                        xPlayer.setInventoryItem(name, xItem.limit)
                    end
                else
                    Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                    return
                end
            else
                --xPlayer.addInventoryItem(name, count)
            end
        else
                --xPlayer.addInventoryItem(name, count)
                 --------------------------------------------------------------------------------------------
                            --กระเป๋า NC แก้ไข
                            local limit = exports.nc_inventory:GetItemLimit(name) --NC
                            local weight = exports.nc_inventory:GetItemWeight(name) -- น้ำหนักไอเทม
                            local _weight, _maxWeight = exports.nc_inventory:GetInventoryWeight(xPlayer.source)
                            local limit_check = nil
                            local _weightitem = 0
                            if limit == -1 then
                                limit_check = true
                                _weightitem = _weight + weight
                                print(_weightitem ,weight ,_maxWeight ,_weight)
                            else
                                limit_check = false
                            end
                            --------------------------------------------------------------------------------------------
                            if limit_check then
                                if limit_check and _weightitem <= _maxWeight  then
                                    if xPlayer.canCarryItem(name, count) then
                                        xPlayer.addInventoryItem(name, count)
                                        exports.nc_discordlogs:Discord({
                                            webhook = '|Bot_uilt_jobs_additem|',			-- ใส่ชื่อ webhook ที่ต้องการใน Config.Webhooks
                                            xPlayer = xPlayer,					-- ในฝั่ง Server ต้องใส่ xPlayer ทุกครั้ง (ตัวอย่างการประกาศค่า xPlayer: local xPlayer = ESX.GetPlayerFromId(playerId))
                                            title = 'ได้รับไอเทม',					-- หัวเรื่องที่ต้องการแสดงใน discord
                                            message = 'ผู้เล่น'	.. xPlayer.name .. ' ได้รับ ' .. xItem.label .. ' จำนวน ' .. ESX.Math.GroupDigits(count) .. ' เข้าตัว',				-- message คือ title ที่จะนำหน้าด้วยชื่อผู้เล่น (หากใช้งาน title และ message พร้อมกัน จะแสดงค่าเป็น title แทน)
                                            public = false,			-- แสดง Log สาธารณะ (true: ไม่แสดงข้อมูลผู้เล่น | false|nil: แสดงข้อมูลผู้เล่น) | Default: nil
                                        })
                                    end
                                else
                                    Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                                    auto = false
                                end
                            --------------------------------------------------------------------------------------------
                            elseif xItem.count <= limit then -- NC
                                    xPlayer.addInventoryItem(name, count)
                                    exports.nc_discordlogs:Discord({
                                        webhook = '|Bot_uilt_jobs_additem|',			-- ใส่ชื่อ webhook ที่ต้องการใน Config.Webhooks
                                        xPlayer = xPlayer,					-- ในฝั่ง Server ต้องใส่ xPlayer ทุกครั้ง (ตัวอย่างการประกาศค่า xPlayer: local xPlayer = ESX.GetPlayerFromId(playerId))
                                        title = 'ได้รับไอเทม',					-- หัวเรื่องที่ต้องการแสดงใน discord
                                        message = 'ผู้เล่น'	.. xPlayer.name .. ' ได้รับ ' .. xItem.label .. ' จำนวน ' .. ESX.Math.GroupDigits(count) .. ' เข้าตัว',				-- message คือ title ที่จะนำหน้าด้วยชื่อผู้เล่น (หากใช้งาน title และ message พร้อมกัน จะแสดงค่าเป็น title แทน)
                                        public = false,			-- แสดง Log สาธารณะ (true: ไม่แสดงข้อมูลผู้เล่น | false|nil: แสดงข้อมูลผู้เล่น) | Default: nil
                                    })
                            else
                                Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                            end
                            --------------------------------------------------------------------------------------------
        end
    end
end)

ChechRareItem = function(playerId, name)
    local config = Config.RareItemAlert
    local rare = false
    for k, v in pairs(config) do 
        if k == name then
            rare = true
            break
        end
    end

    if rare then
        TriggerClientEvent('uilt_jobs:TaskRareAnimation', playerId, name)
    end
end

CreateRandomItems = function(list)
    local itemList = list
      local collect = {}
    local getItems = {}
  
    for i=1, #itemList do
      if not itemList[i].Percent then
        rawset(getItems, #getItems + 1, {
          ItemName = itemList[i].ItemName,
          ItemCount = itemList[i].ItemCount
        })
      else
        for j = 1, itemList[i].Percent do
            rawset(collect, #collect + 1, {
            ItemName = itemList[i].ItemName,
            ItemCount = itemList[i].ItemCount
          })
        end
      end
    end
  
    -- check it fully
    local upTo100 = #collect
    if upTo100 < 100 then
      for i = upTo100 + 1, 100 , 1 do
        rawset(collect, i, false)
      end
    end
  
    math.randomseed(GetGameTimer())
    local count = #collect
    local rand = math.random(count)
    local randomItem = collect[rand]
  
    -- insert random item
    if randomItem then
      rawset(getItems, #getItems+1, randomItem)
    end
  
      for i=1, count do collect[i] = nil end
  
      return getItems
  end




RegisterServerEvent('uilt_jobs:MoneyPayTaskFristMone')
AddEventHandler('uilt_jobs:MoneyPayTaskFristMone', function(data)
      local _Tex = data
      local xPlayer = ESX.GetPlayerFromId(source)
      local _bank = xPlayer.getAccount('bank').money
              if xPlayer.getMoney() >= _Tex then
                    TriggerClientEvent("TaskFristMode:Check", source , true)
                  xPlayer.removeAccountMoney('money', _Tex) 
              elseif _bank >= _Tex then
                    TriggerClientEvent("TaskFristMode:Check", source , true)
                  xPlayer.removeAccountMoney('bank', _Tex)  
              else
                exports.mongodb:insertOne({ collection="billing", 
				document = { 
					identifier		= xPlayer.identifier,
					sender			= 'City',
					target_type		= 'player',
					target			= xPlayer.identifier,
					label			= 'ใบภาษีเช่าที่ทำงาน',
					amount			= _Tex,
					jobs			= 'ไม่มี',
					-- time			= os.date("วัน:%d เดือน:%m ปี:%Y เวลา(%H น. %M นาที่)")
                    time			= os.date("%d/%m/%Y(%H | %M )")
				} }, function (success, result)
					if not success then
						print("[mongodb][Example] Error in insertOne: "..tostring(result))
						return
					end 
				end)
            TriggerClientEvent("TaskFristMode:Check", source , true)
        end
end)

RegisterServerEvent('uilt_jobs:MoneyPayTaskSecondeMone')
AddEventHandler('uilt_jobs:MoneyPayTaskSecondeMone', function(data)
    local _Tex = data
    local xPlayer = ESX.GetPlayerFromId(source)
    local _bank = xPlayer.getAccount('bank').money
            if xPlayer.getMoney() >= _Tex then
                TriggerClientEvent("TaskSecondMode:Check", source , true)
                xPlayer.removeAccountMoney('money', _Tex)
                
            elseif _bank >= _Tex then
                TriggerClientEvent("TaskSecondMode:Check", source , true)
                xPlayer.removeAccountMoney('bank', _Tex)
                
            else
                TriggerClientEvent("TaskSecondMode:Check", source , false)
            end
end)