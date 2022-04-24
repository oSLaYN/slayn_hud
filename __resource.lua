resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

author 'oSLaYN - https://github.com/oSLaYN'
version '1.0.0'

client_scripts {
	'@es_extended/locale.lua',
	'client/client.lua'
}

shared_script 'config.lua'

server_scripts {
	'@es_extended/locale.lua',
	'@oxmysql/lib/MySQL.lua',
	'server/server.lua'
}

ui_page('html/index.html')

files({
	"html/script.js",
	"html/jquery.min.js",
	"html/jquery-ui.min.js",
	"html/styles.css",
	"html/img/*.svg",
	"html/img/*.png",
	"html/index.html",
})

exports {
	'setTalking',
	'setVolume',
	'setThirst',
	'setHunger',
	'setStress',
	'addThirst',
	'addHunger',
	'addStress',
	'removeThirst',
	'removeHunger',
	'removeStress'
}