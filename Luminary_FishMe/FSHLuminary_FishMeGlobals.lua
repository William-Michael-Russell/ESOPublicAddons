mSavedFHVars = {}

mFSHConfig = {
  appName = "Luminary_FishMe",
  addonIsLoaded = false,
  allowAlert = true,
  quickdeactivate = false,
  MOTD_Save = {},
  Version = 3.14,
  tempDisableAlerts = false,
  is_shouldFish = true,
  resetFish = false,
  wasFish = false,
  isFishCounter = 0,
  is_StoreClosed = 0,
  setYourBait = false,
  openclose = 0,
  col = {
    colMagic     = "|c2dc50e", -- Magic Green (Uncommon)
    colTrash     = "|c777777", -- Trash Gray (Garbage)
    colYellow    = "|cFFFF00" ,--yellow
    colArcane    = "|c3689ef", -- Arcane Blue (Rare)
    colArtifact  = "|c912be1", -- Epic (Epic)
    colTeal      = "|c00FFFF", -- teal
    colWhite     = "|cFFFFFF", -- white
    colRed       = "|cFF0000", -- Red
    colLegendary = "|cd5b526", -- Legendary Gold (TheShit)
    colGreen     = "|c00FF00" --green
  }
}

function getFSColor()
  return mFSHConfig.col
end