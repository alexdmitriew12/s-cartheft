fx_version 'cerulean'
game 'gta5'

author 'wx / woox'
description 'Advanced recoil system for FiveM'

client_scripts {
    'client/client.lua',
}

server_script {
   'server/server.lua'
}

shared_scripts {
    'config.lua'
}

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/img/*.png',

}

ui_page 'ui/index.html'
