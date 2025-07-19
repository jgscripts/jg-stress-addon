local Config = lib.load('config')

local function loadframework()
  local frameworks = {
    { name = 'esx', resource = 'es_extended' },
    { name = 'qbx', resource = 'qbx_core' },
    { name = 'qb', resource = 'qb-core' }
  }
  
  for _, fw in ipairs(frameworks) do
    if GetResourceState(fw.resource) == 'started' then
      return fw.name
    end
  end
end

local framework = loadframework()
local FrameworkObject = nil

if framework == 'esx' then
  FrameworkObject = exports['es_extended']:getSharedObject()
elseif framework == 'qb' then
  FrameworkObject = exports['qb-core']:GetCoreObject()
end

local speedMultiplier = Config.UseMPH and 2.23694 or 3.6

local function getStress()
  return LocalPlayer.state?.stress or 0
end

local function isJobWhitelisted()
  if framework == 'esx' then
    local PlayerData = FrameworkObject.GetPlayerData()
    local currentJob = PlayerData?.job?.name
    if not currentJob then return false end
    return lib.table.contains(Config.WhitelistedJobs, currentJob)
  elseif framework == 'qbx' then
  local PlayerData = exports.qbx_core:GetPlayerData()
  if not PlayerData?.job?.name then return false end
  return lib.table.contains(Config.WhitelistedJobs, PlayerData.job.name)
  elseif framework == 'qb' then
    local PlayerData = FrameworkObject.Functions.GetPlayerData()
    local currentJob = PlayerData?.job?.name
    if not currentJob then return false end
    return lib.table.contains(Config.WhitelistedJobs, currentJob)
  end
  return false
end

local function gainStress(amount)
  if isJobWhitelisted() then return end
  local state = LocalPlayer.state
  if not state then return end
  local newStress = getStress() + amount
  state:set('stress', newStress, true)
  TriggerServerEvent('updateStress', newStress)
end

local function startVehicleStressThread()
  CreateThread(function()
    Wait(1)
    while cache.vehicle do
      if not isJobWhitelisted() then
        local vehClass = GetVehicleClass(cache.vehicle)
        local speed = GetEntitySpeed(cache.vehicle) * speedMultiplier
        if vehClass ~= 13 and vehClass ~= 14 and vehClass ~= 15 and vehClass ~= 16 and vehClass ~= 21 then
          local stressSpeed = vehClass == 8 and Config.Stress.minForSpeeding or (LocalPlayer.state?.seatbelt and Config.Stress.minForSpeeding or Config.Stress.minForSpeedingUnbuckled)
          if speed >= stressSpeed then
            gainStress(math.random(1, 3))
          end
        end
      end
      Wait(1000)
    end
  end)
end

lib.onCache('vehicle', function(vehicle)
  if not vehicle then return end
  startVehicleStressThread()
end)

CreateThread(function()
  if cache.vehicle then
    startVehicleStressThread()
  end
end)

local function isWhitelistedWeaponStress(weapon)
  if not weapon then return false end
  return lib.table.contains(Config.Stress.whitelistedWeapons, weapon)
end

local currentWeaponThread = nil

local function startWeaponStressThread(weapon)
  if currentWeaponThread then
    currentWeaponThread = nil
  end
  
  if isWhitelistedWeaponStress(weapon) then return end
  
  currentWeaponThread = CreateThread(function()
    local thisThread = currentWeaponThread
    Wait(1)
    while cache.weapon and thisThread == currentWeaponThread do
      if not isWhitelistedWeaponStress(cache.weapon) and IsPedShooting(cache.ped) and math.random() <= Config.Stress.chance then
        gainStress(math.random(1, 5))
      end
      Wait(0)
    end
  end)
end

lib.onCache('weapon', function(weapon)
  if not weapon then 
    currentWeaponThread = nil
    return 
  end
  startWeaponStressThread(weapon)
end)

CreateThread(function()
  if cache.weapon then
    startWeaponStressThread(cache.weapon)
  end
end)

local function getBlurIntensity(stresslevel)
  for _, v in pairs(Config.Stress.blurIntensity) do
    if lib.math.clamp(stresslevel, v.min, v.max) == stresslevel then
      return v.intensity
    end
  end
  return 1500
end

local function getEffectInterval(stresslevel)
  for _, v in pairs(Config.Stress.effectInterval) do
    if lib.math.clamp(stresslevel, v.min, v.max) == stresslevel then
      return v.timeout
    end
  end
  return 60000
end

CreateThread(function()
  while true do
    local stress = getStress()
    local effectInterval = getEffectInterval(stress)
    
    if not isJobWhitelisted() then
      if stress >= 100 then
        local blurIntensity = getBlurIntensity(stress)
        local fallRepeat = math.random(2, 4)
        local ragdollTimeout = fallRepeat * 1750
        TriggerScreenblurFadeIn(1000.0)
        Wait(blurIntensity)
        TriggerScreenblurFadeOut(1000.0)
        if not IsPedRagdoll(cache.ped) and IsPedOnFoot(cache.ped) and not IsPedSwimming(cache.ped) then
          local forwardVector = GetEntityForwardVector(cache.ped)
          SetPedToRagdollWithFall(cache.ped, ragdollTimeout, ragdollTimeout, 1, forwardVector.x, forwardVector.y, forwardVector.z, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        end
        Wait(1000)
        for _ = 1, fallRepeat, 1 do
          Wait(750)
          DoScreenFadeOut(200)
          Wait(1000)
          DoScreenFadeIn(200)
          TriggerScreenblurFadeIn(1000.0)
          Wait(blurIntensity)
          TriggerScreenblurFadeOut(1000.0)
        end
      elseif stress >= Config.Stress.minForShaking then
        local blurIntensity = getBlurIntensity(stress)
        TriggerScreenblurFadeIn(1000.0)
        Wait(blurIntensity)
        TriggerScreenblurFadeOut(1000.0)
      end
    end
    Wait(effectInterval)
  end
end)