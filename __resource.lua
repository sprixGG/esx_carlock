

resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

client_scripts {
	"@es_extended/locale.lua",
    "clienten.lua",
	'@mysql-async/lib/MySQL.lua'
}

server_scripts {
	"server.lua",
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua'
	
}