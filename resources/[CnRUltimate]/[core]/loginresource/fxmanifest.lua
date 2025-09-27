fx_version "cerulean"
game "gta5"

ui_page "ui/index.html"

files {
    "ui/**"
}

client_script "client.lua"
server_script "server.lua"
shared_script '@oxmysql/lib/MySQL.lua'