local framework = GetFramework()
local frameworkObject

if framework == 'esx' then
  DebugPrint('Loading ESX object')
  frameworkObject = exports['es_extended']:getSharedObject()
elseif framework == 'qb' then
  DebugPrint('Loading QB-Core object')
  frameworkObject = exports['qb-core']:GetCoreObject()
end

local Whitelist = lib.load('client/whitelist')(framework, frameworkObject)
local Stress    = lib.load('client/stress')(Whitelist.isJobWhitelisted)

lib.load('client/vehicle')(Stress.gainStress, Whitelist.isJobWhitelisted, Whitelist.isVehicleWhitelisted)
lib.load('client/weapon')(Stress.gainStress)
lib.load('client/effects')(Stress.getStress, Whitelist.isJobWhitelisted)

exports('getStress',              Stress.getStress)
exports('gainStress',             Stress.gainStress)
exports('isPlayerJobWhitelisted', Whitelist.isJobWhitelisted)
exports('isVehicleWhitelisted',   Whitelist.isVehicleWhitelisted)
exports('resetStress',            Stress.resetStress)
exports('setStressLevel',         Stress.setStressLevel)
