resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description 'Pepe Hud'

server_scripts {
	"config.lua",
	"server/main.lua",
}

client_scripts {
	"config.lua",
	"client/main.lua",
	"client/ui.lua",
}

ui_page {
	'html/ui.html'
}

exports {
	'SetSeatbelt',
}

files {
	'html/*.png',
	'html/*.svg',
	'html/*.html',
	'html/ui.html',
	'html/css/main.css',
	'html/css/pricedown_bl-webfont.ttf',
	'html/css/pricedown_bl-webfont.woff',
	'html/css/pricedown_bl-webfont.woff2',
	'html/css/gta-ui.ttf',
	'html/js/app.js',
	'html/js/radial.js',
	'html/css/pdown.ttf',
	'html/css/*.css',
	'html/css/*.ttf',
	'html/css/*.woff',
	'html/css/*.woff2',
}