fx_version 'adamant'
games { 'gta5' };

name 'RageUI';
description 'Le.V_Core LUA'

client_scripts {
    "src/client/RMenu.lua",
    "src/client/menu/RageUI.lua",
    "src/client/menu/Menu.lua",
    "src/client/menu/MenuController.lua",
    "src/client/components/*.lua",
    "src/client/menu/elements/*.lua",
    "src/client/menu/items/*.lua",
    "src/client/menu/panels/*.lua",
    "src/client/menu/windows/*.lua",
}

client_scripts {
	'@es_extended/locale.lua',
	'menuf5_c.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'menuf5_s.lua'
}



