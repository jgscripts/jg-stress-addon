fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
description 'For support or other queries: discord.gg/jgscripts'
repository 'https://github.com/jgscripts/jg-stress-addon'
version '2.0.2'

client_scripts {
  'client/init.lua',
  'client/vehicle.lua',
  'client/weapon.lua',
  'client/effects.lua',
  'client/whitelist.lua',
  'client/stress.lua'
}

shared_scripts {
  '@ox_lib/init.lua',
  'shared/utils.lua',
  'config/config.lua',
}

server_script 'server/server.lua'
