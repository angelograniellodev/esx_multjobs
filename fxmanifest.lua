fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author '@devangelo25 on discord'
description 'ESX Multijobs System'
version '1.0.0'

shared_scripts {
    'shared/*.lua',
    '@es_extended/imports.lua'
}

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
    '@oxmysql/lib/MySQL.lua',
}

ui_page 'dist/ui.html'

files {
    'dist/ui.html',
    'dist/files/css/*.css',
    'dist/files/assets/*.ogg',
    'dist/files/js/*.js'
}

lua54 'yes'