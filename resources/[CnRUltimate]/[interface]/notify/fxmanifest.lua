-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'Seu Nome (via AI)'
description 'Um sistema de notificação simples e elegante para FiveM.'
version '1.0.0'

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js'
}

client_script 'client.lua'

export 'notify'