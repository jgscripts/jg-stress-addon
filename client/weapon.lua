local Config = lib.require('config.config')

local STRESS_GAIN_MIN = 1
local STRESS_GAIN_MAX = 5
local WEAPON_STRESS_DEBOUNCE = 1000

return function(gainStress)
  local activeThreadId = 0

  local function isWeaponWhitelisted(weapon)
    return lib.table.contains(Config.Stress.whitelistedWeapons, weapon)
  end

  local function startWeaponStressThread(weapon)
    local myThreadId = activeThreadId + 1
    activeThreadId = myThreadId
    if isWeaponWhitelisted(weapon) then
      DebugPrint('Weapon %s is whitelisted, skipping thread', weapon)
      return
    end

    DebugPrint('Starting weapon stress thread for: %s', weapon)
    CreateThread(function()
      while cache.weapon and activeThreadId == myThreadId do
        if IsPedShooting(cache.ped) and math.random() <= Config.Stress.chance then
          DebugPrint('Shooting with non-whitelisted weapon: %s', cache.weapon)
          gainStress(math.random(STRESS_GAIN_MIN, STRESS_GAIN_MAX))
          Wait(WEAPON_STRESS_DEBOUNCE)
        else
          Wait(0)
        end
      end
      DebugPrint('Weapon stress thread exited')
    end)
  end

  lib.onCache('weapon', function(weapon)
    if not weapon then
      activeThreadId = activeThreadId + 1 -- invalidate any running thread
      DebugPrint('Weapon cleared, stopping weapon thread')
      return
    end
    startWeaponStressThread(weapon)
  end)

  if cache.weapon then
    startWeaponStressThread(cache.weapon)
  end
end
