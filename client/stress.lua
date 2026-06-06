return function(isJobWhitelisted)
  -- sv_stateBagStrictMode blocks clients from replicating their own statebag, so every write is
  -- requested from the server, which validates and performs it. Reads stay client-side.
  ---@return number
  local function getStress()
    return LocalPlayer.state?.stress or 0
  end

  ---@param amount number
  local function gainStress(amount)
    if isJobWhitelisted() then
      DebugPrint('Skipped stress gain due to whitelist')
      return
    end
    TriggerServerEvent('jg-stress-addon:server:gainStress', amount)
  end

  local function resetStress()
    TriggerServerEvent('jg-stress-addon:server:resetStress')
  end

  ---@param amount number
  local function setStressLevel(amount)
    TriggerServerEvent('jg-stress-addon:server:setStress', amount)
  end

  return {
    getStress      = getStress,
    gainStress     = gainStress,
    resetStress    = resetStress,
    setStressLevel = setStressLevel,
  }
end
