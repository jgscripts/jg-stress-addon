fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
description 'For support or other queries: discord.gg/jgscripts'
repository 'https://github.com/jgscripts/jg-stress-addon'
version '2.1.1'

shared_scripts {
  '@ox_lib/init.lua',
  'shared/utils.lua',
  'config/config.lua',
}

client_scripts {
    'client/init.lua',
  -- soooo apparently I cant just put this in files {}, kiiinda stupid
  'client/whitelist.lua',
  'client/stress.lua',
  'client/vehicle.lua',
  'client/weapon.lua',
  'client/effects.lua',
}

server_scripts {
  'server/server.lua',
  'server/sv-versioncheck.lua',
}
