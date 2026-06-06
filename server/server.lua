local Config = lib.require('config.config')

if Config.VersionCheck then
  lib.versionCheck('jgscripts/jg-stress-addon')
end
---@param src integer
---@return number
local function getStress(src)
  return Player(src)?.state?.stress or 0
end


---@param src integer
---@param value number
local function setStress(src, value)
  if type(value) ~= 'number' then return end
  local state = Player(src)?.state
  if not state then return end
  state:set('stress', lib.math.clamp(value, MIN_STRESS, MAX_STRESS), true)
end

---@param src integer
---@param amount number
local function gainStress(src, amount)
  if type(amount) ~= 'number' then return end
  local player = GetPlayer(src)
  if not player then return end
  if Config.Stress.disableForLEO and player.PlayerData?.job?.type == 'leo' then return end
  setStress(src, getStress(src) + amount)
end

---@param src integer
---@param amount number
local function relieveStress(src, amount)
  if type(amount) ~= 'number' then return end
  setStress(src, getStress(src) - amount)
end

RegisterNetEvent('jg-stress-addon:server:gainStress', function(amount)
  gainStress(source, amount)
end)

RegisterNetEvent('jg-stress-addon:server:setStress', function(amount)
  setStress(source, amount)
end)

RegisterNetEvent('jg-stress-addon:server:resetStress', function()
  setStress(source, MIN_STRESS)
end)


RegisterNetEvent('hud:server:GainStress', function(amount)
  gainStress(source, amount)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
  relieveStress(source, amount)
end)

exports('relieveStress', relieveStress)
exports('gainStress', gainStress)
exports('getStress', getStress)
