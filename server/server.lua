local resetStress = false
local Config = lib.require('config.config')

local function getStress(src)
  return Player(src)?.state?.stress or 0
end

local function gainStress(src, amount)
  local player = GetPlayer(src)
  if not player then return end
  if Config.Stress.disableForLEO and player.PlayerData.job?.type == 'leo' then return end

  local newStress
  if not resetStress then
    newStress = getStress(src) + amount
    if newStress <= 0 then newStress = 0 end
  else
    newStress = 0
  end
  if newStress > 100 then
    newStress = 100
  end

  Player(src)?.state:set('stress', newStress, true)
end

local function relieveStress(src, amount)
  local newStress
  if not resetStress then
    newStress = getStress(src) - amount
    if newStress <= 0 then newStress = 0 end
  else
    newStress = 0
  end
  if newStress > 100 then
    newStress = 100
  end

  Player(src)?.state:set('stress', newStress, true)
end

RegisterNetEvent('hud:server:GainStress', function(amount)
  gainStress(source, amount)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
  relieveStress(source, amount)
end)

RegisterNetEvent('updateStress', function(newStress)
  local src = source
  if not newStress then return end

  if newStress < 0 then newStress = 0 end
  if newStress > 100 then newStress = 100 end

  local player = Player(src)
  if not player then return end

  player.state:set('stress', newStress, true)
end)

exports('relieveStress', relieveStress)
exports('gainStress', gainStress)
exports('getStress', getStress)
