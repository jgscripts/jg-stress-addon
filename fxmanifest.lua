fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

description 'For support or other queries: discord.gg/jgscripts'
version '1.3'
repository 'https://github.com/jgscripts/jg-stress-addon'

client_script 'client.lua'

shared_scripts {
  '@ox_lib/init.lua',
  'config.lua',
}

server_script 'server.lua'
