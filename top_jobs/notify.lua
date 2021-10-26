Notify = {}

Notify.Client = function (txt,type)
    TriggerEvent("pNotify:SendNotification", {
        text = txt,
        type = type,
        timeout = 2500,
        layout = "bottomCenter"
    })
end

Notify.Server = function (txt,type,player)
    TriggerClientEvent("pNotify:SendNotification", player, {
        text = txt,
        type = type,
        timeout = 2500,
        layout = "bottomCenter"
    })
end