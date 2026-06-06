local Config = lib.require('config.config')

MIN_STRESS = 0
MAX_STRESS = 100

local function resolveFramework()
  if GetResourceState('qbx_core') == 'started' then
    return 'qbx'
  elseif GetResourceState('qb-core') == 'started' then
    return 'qb'
  elseif GetResourceState('es_extended') == 'started' then
    return 'esx'
  end
end

local framework = resolveFramework()

---Returns the detected framework, or nil when running standalone.
---@return string? framework 'qbx' | 'qb' | 'esx' | nil
function GetFramework()
  return framework
end

---@param fmt string
function DebugPrint(fmt, ...)
  if Config.Debug then
    print('[DEBUG] ' .. string.format(fmt, ...))
  end
end

---@param src integer
function GetPlayer(src)
  if framework == 'qbx' then
    return exports.qbx_core:GetPlayer(src)
  elseif framework == 'qb' then
    return exports['qb-core']:GetPlayer(src) -- only if qb-core ver > 1.3 as per https://docs.qbcore.org/qbcore-documentation/qb-core/core-object#exported-functions
  elseif framework == 'esx' then
    return exports.es_extended:getSharedObject().GetPlayerFromId(src)
  end
end
