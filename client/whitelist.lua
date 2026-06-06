local Config = lib.require('config.config')

return function(framework, frameworkObject)
  local whitelistedJobs = {}
  local jobs = Config.WhitelistedJobs or {}
  for i = 1, #jobs do
    whitelistedJobs[jobs[i]] = true
  end

  local whitelistedVehicles = {}
  local vehicles = Config.WhitelistedVehicles or {}
  for i = 1, #vehicles do
    whitelistedVehicles[joaat(vehicles[i])] = true
  end

  local function getPlayerData()
    if framework == 'esx' and frameworkObject then
      return frameworkObject.GetPlayerData()
    elseif framework == 'qbx' then
      return exports.qbx_core:GetPlayerData()
    elseif framework == 'qb' and frameworkObject then
      return frameworkObject.Functions.GetPlayerData()
    end
    DebugPrint('getPlayerData: no framework matched (framework=%s)', tostring(framework))
  end

  ---@return boolean
  local function isJobWhitelisted()
    if not next(whitelistedJobs) then return false end
    local currentJob = getPlayerData()?.job?.name
    DebugPrint('Job (%s): %s', tostring(framework), tostring(currentJob))
    return whitelistedJobs[currentJob] == true
  end

  ---@param vehicle? integer Defaults to the player's current vehicle.
  ---@return boolean
  local function isVehicleWhitelisted(vehicle)
    if not next(whitelistedVehicles) then return false end
    vehicle = vehicle or cache.vehicle
    if not vehicle or vehicle == 0 then return false end
    local result = whitelistedVehicles[GetEntityModel(vehicle)] == true
    DebugPrint('Vehicle whitelist check (%s): %s', vehicle, result)
    return result
  end

  return {
    isJobWhitelisted     = isJobWhitelisted,
    isVehicleWhitelisted = isVehicleWhitelisted,
  }
end
