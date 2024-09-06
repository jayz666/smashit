fx_version 'cerulean'
game 'gta5'

author 'Moorgaming'
description 'Smash vehicle windows and search for items in QB-Core with qb-target'
version '1.0.0'

-- Client and server scripts
client_scripts {
    'config.lua',
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'qb-core',
    'qb-target'
}



