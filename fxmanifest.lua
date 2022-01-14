fx_version  'cerulean'
game        'gta5'
author      'Akkariin'
description 'FiveM Advanced Screenshots'
url         'https://www.zerodream.net/'
ui_page     'index.html'

-- Files
files {
    'index.html',
}

shared_scripts {
    'config.lua',
}

-- Client Scripts
client_scripts {
    'warmenu.lua',
    'client.lua',
}

-- Server Scripts
server_scripts {
    'server.lua',
}

exports {
    'SetPageStatus',
    'TakeScreenshot',
    'AddScreenshots',
    'IsPageOpened',
}