fx_version 'bodacious'
game 'gta5'

author 'You'
version '1.0.0'

ui_page "html/index.html"

shared_scripts {
    'config.lua',
    'notify.lua',
    'shared/shared.lua'
}

client_scripts {
    'client/var.lua',
    'client/func.lua',
    'client/event.lua',
    'client/thread.lua'
}

server_scripts {
    'server/main.lua'
}


files {
    "html/sound/*.mp3",
    "html/ui.css",
    "html/script.js",
    "html/index.html",
}