return {

Debug = false, -- Loads of prints in F8
UseMPH = false, -- Use MPH instead of KPH

Stress = {
  chance = 0.1, -- Percentage stress chance when shooting (0-1)
  minForShaking = 50, -- Minimum stress level for screen shaking
  speedThresholdBuckled = 1000, -- Speed threshold (in KPH/MPH per Config.UseMPH) above which buckled driving causes stress
        speedThresholdUnbuckled = 50, -- Speed threshold (in KPH/MPH per Config.UseMPH) above which unbuckled driving causes stress
    disableForLEO = false, -- If true, players whose job.type == 'leo' gain no stress (QB/QBX only. ESX has no job.type)
    whitelistedWeapons = { -- Weapons which don't give stress
      `weapon_petrolcan`, -- Please use backticks (`) not quotes ('/')
      `weapon_hazardcan`,
      `weapon_fireextinguisher`,
    },
    blurIntensity = { -- Blur intensity for different stress levels (ranges are inclusive on both ends)
      [1] = {min = 50, max = 59, intensity = 1500},
      [2] = {min = 60, max = 69, intensity = 2000},
      [3] = {min = 70, max = 79, intensity = 2500},
      [4] = {min = 80, max = 89, intensity = 2700},
      [5] = {min = 90, max = 100, intensity = 3000},
    },
    -- Effect interval for different stress levels (ranges are inclusive on both ends).
    -- The timeout values are rolled once at resource start via math.random and stay fixed per server boot.
    effectInterval = {
      [1] = {min = 50, max = 59, timeout = math.random(50000, 60000)},
      [2] = {min = 60, max = 69, timeout = math.random(40000, 50000)},
      [3] = {min = 70, max = 79, timeout = math.random(30000, 40000)},
      [4] = {min = 80, max = 89, timeout = math.random(20000, 30000)},
      [5] = {min = 90, max = 100, timeout = math.random(15000, 20000)},
    },
},

  WhitelistedJobs = {'police', 'police2'} -- Disable stress for whatever jobs you want

}
