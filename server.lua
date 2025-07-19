local resetStress = false

--[[ RegisterNetEvent('hud:server:GainStress', function(amount)
    local src = source
    local player = exports.qbx_core:GetPlayer(src)
    local newStress
    
    if not player or (Config.stress.disableForLEO and player.PlayerData.job.type == 'leo') then return end
    if not resetStress then
      if not player.PlayerData.metadata.stress then
        player.PlayerData.metadata.stress = 0
      end
      newStress = player.PlayerData.metadata.stress + amount
      if newStress <= 0 then newStress = 0 end
    else
      newStress = 0
    end
    if newStress > 100 then
      newStress = 100
    end

    Player(src)?.state:set('stress', newStress, true)
    -- exports.qbx_core:Notify(src, locale('notify.stress_gain'), 'inform', 2500, nil, nil, {'#141517', '#ffffff'}, 'brain', '#C53030')
end) ]]

local function getStress(src)
  return Player(src)?.state?.stress or 0
end

RegisterNetEvent('updateStress', function(newStress)
  local src = source
  if not newStress then return end
  
  if newStress < 0 then newStress = 0 end
  if newStress > 100 then newStress = 100 end
  
  local player = Player(src)
  if not player then return end
  
  player.state:set('stress', newStress, true)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
  local src = source
  local stress = getStress(src)
  local newStress

  if not resetStress then
    if not stress then
      stress = 0
    end
    newStress = stress - amount
    if newStress <= 0 then newStress = 0 end
  else
    newStress = 0
  end
  if newStress > 100 then
    newStress = 100
  end
  
  Player(src).state:set('stress', newStress, true)
  -- exports.qbx_core:Notify(src, locale('notify.stress_removed'), 'inform', 2500, nil, nil, {'#141517', '#ffffff'}, 'brain', '#0F52BA')
end)