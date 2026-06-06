local Config = lib.require('config.config')

local DEFAULT_BLUR_INTENSITY = 1500
local DEFAULT_EFFECT_INTERVAL = 60000
local BLUR_FADE_MS = 1000.0

return function(getStress, isJobWhitelisted)
  ---Find the configured band whose [min, max] range contains stressLevel.
  ---@param bands table
  ---@param stressLevel number
  local function findBand(bands, stressLevel)
    for i = 1, #bands do
      local band = bands[i]
      if stressLevel >= band.min and stressLevel <= band.max then
        return band
      end
    end
  end

  local function getBlurIntensity(stressLevel)
    local band = findBand(Config.Stress.blurIntensity, stressLevel)
    return band and band.intensity or DEFAULT_BLUR_INTENSITY
  end

  local function getEffectInterval(stressLevel)
    local band = findBand(Config.Stress.effectInterval, stressLevel)
    if not band then return DEFAULT_EFFECT_INTERVAL end
    return math.random(band.timeoutMin, band.timeoutMax)
  end

  local function applyBlur(blurIntensity)
    TriggerScreenblurFadeIn(BLUR_FADE_MS)
    Wait(blurIntensity)
    TriggerScreenblurFadeOut(BLUR_FADE_MS)
  end

  local function applyFullStressEffect(blurIntensity)
    local fallRepeat = math.random(2, 4)
    local ragdollTimeout = fallRepeat * 1750

    applyBlur(blurIntensity)

    local ped = cache.ped
    if not IsPedRagdoll(ped) and IsPedOnFoot(ped) and not IsPedSwimming(ped) then
      local fwd = GetEntityForwardVector(ped)
      DebugPrint('Applying ragdoll fall effect')
      SetPedToRagdollWithFall(ped, ragdollTimeout, ragdollTimeout, 1, fwd.x, fwd.y, fwd.z, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end

    Wait(1000)
    for _ = 1, fallRepeat do
      Wait(750)
      DoScreenFadeOut(200)
      Wait(1000)
      DoScreenFadeIn(200)
      applyBlur(blurIntensity)
    end
  end

  CreateThread(function()
    DebugPrint('Starting stress effects loop')
    while true do
      local stress = getStress()

      if not isJobWhitelisted() then
        local blurIntensity = getBlurIntensity(stress)
        if stress >= MAX_STRESS then
          DebugPrint('Stress >= %s, triggering full effect', MAX_STRESS)
          applyFullStressEffect(blurIntensity)
        elseif stress >= Config.Stress.minForShaking then
          DebugPrint('Stress >= %s, applying screen blur', Config.Stress.minForShaking)
          applyBlur(blurIntensity)
        end
      end

      Wait(getEffectInterval(stress))
    end
  end)
end
