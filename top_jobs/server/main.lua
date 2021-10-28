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

RegisterServerEvent('top_jobs:useitemEnable')
AddEventHandler('top_jobs:useitemEnable', function(data)
    ESX.RegisterUsableItem(data, function(source)
        local xPlayer = ESX.GetPlayerFromId(source)

    end)
end)

RegisterServerEvent('top_jobs:processItems')
AddEventHandler('top_jobs:processItems', function(data, data2, auto)
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
        if Config.ESXOLD then
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
                if xPlayer.canCarryItem(name, count) then
                    itemList[i].ItemCount = count
                else
                    Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                end
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

        if Config.ESXOLD then
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
            if xPlayer.canCarryItem(name, count) then
                xPlayer.addInventoryItem(name, count)
                ChechRareItem(xPlayer.source, xItem.name)
            else
                Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
            end
        end

    end

    if auto then
        TriggerClientEvent('top_jobs:TaskProcess', xPlayer.source, true)
    end
end)

RegisterServerEvent('top_jobs:checkitem')
AddEventHandler('top_jobs:checkitem', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getInventoryItem(data).count >= 1 then
        TriggerClientEvent('top_jobs:Returncheckitem', source, true)
       -- print("HI")
    else
        TriggerClientEvent('top_jobs:Returncheckitem', source, false)
       -- print("BAD")
    end
end)

RegisterServerEvent('top_jobs:addItems')
AddEventHandler('top_jobs:addItems', function(data)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemList = CreateRandomItems(data)

    local listCount = #itemList
    for i=1, listCount do 
        local name = itemList[i].ItemName
        local count = math.random(itemList[i].ItemCount[1], itemList[i].ItemCount[2])

        local xItem = xPlayer.getInventoryItem(name)
        if Config.ESXOLD then
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
                if xPlayer.canCarryItem(name, count) then
                    xPlayer.addInventoryItem(name, count)
                else
                    Notify.Server(Config.Text['bag_full']:format(xItem.label), 'error', xPlayer.source)
                end
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
        TriggerClientEvent('top_jobs:TaskRareAnimation', playerId, name)
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