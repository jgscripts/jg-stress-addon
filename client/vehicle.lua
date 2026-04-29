return function(gainStress, isJobWhitelisted, speedMultiplier, Config)
  local function startVehicleStressThread()
    DebugPrint('Starting vehicle stress thread')
    CreateThread(function()
      Wait(1)
      while cache.vehicle do
        if not isJobWhitelisted() then
          local vehClass = GetVehicleClass(cache.vehicle)
          local speed    = GetEntitySpeed(cache.vehicle) * speedMultiplier
          DebugPrint('Vehicle class: %s | Speed: %.2f', vehClass, speed)

          if vehClass ~= 13 and vehClass ~= 14 and vehClass ~= 15 and vehClass ~= 16 and vehClass ~= 21 then
            local hasSeatbelt = LocalPlayer.state?.seatbelt
            local stressSpeed = (vehClass == 8 or hasSeatbelt) and Config.Stress.speedThresholdBuckled or Config.Stress.speedThresholdUnbuckled
            if speed >= stressSpeed then
              DebugPrint('Speed exceeded threshold (%.2f), applying stress', stressSpeed)
              gainStress(math.random(1, 3))
            end
          end
        end
        Wait(1000)
      end
      DebugPrint('Exited vehicle stress loop')
    end)
  end

  lib.onCache('vehicle', function(vehicle)
    DebugPrint('Vehicle cache updated: %s', vehicle and tostring(vehicle) or 'nil')
    if not vehicle then return end
    startVehicleStressThread()
  end)

  CreateThread(function()
    if cache.vehicle then
      DebugPrint('Vehicle cache present at start, starting stress thread')
      startVehicleStressThread()
    end
  end)
end
