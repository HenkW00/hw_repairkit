fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Repair Kit script with okokNotify integration'
author 'HenkW'
version '1.2.6'

files {
    'locales/*.json'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/version.lua'
}

shared_scripts {
    '@es_extended/imports.lua',
    'config.lua',
    '@ox_lib/init.lua'
}

dependencies {
    -- 'okokNotify',
    'ox_lib',
    'hw_utils'
}

escrow_ignore {
    'config.lua',
    'locales/*.json',
    'fxmanifest.lua',
    'README.MD'
}