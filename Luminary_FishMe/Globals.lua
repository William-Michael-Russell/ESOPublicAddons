FishMe = {}

FishMe.SavedVars = {}

FishMe.DefaultVars = {
   ["Enable_Fish_Bait"] = true,
   ["Enable_Reel_Alerts"] = true,
}

FishMe.Config = {
   appName = "Luminary_FishMe",
   addonIsLoaded = false,
   allowAlert = true,
   quickdeactivate = false,
   Version = "3.16",
   tempDisableAlerts = false,
   is_shouldFish = true,
   resetFish = false,
   wasFish = false,
   isFishCounter = 0,
   is_StoreClosed = 0,
   setYourBait = false,
   openclose = 0,
   colors = {
      Trash     = GetItemQualityColor(ITEM_QUALITY_TRASH),     -- Trash Gray (Garbage)
      White     = GetItemQualityColor(ITEM_QUALITY_NORMAL),    -- white
      Magic     = GetItemQualityColor(ITEM_QUALITY_MAGIC),     -- Magic Green (Uncommon)
      Arcane    = GetItemQualityColor(ITEM_QUALITY_ARCANE),    -- Arcane Blue (Rare)
      Artifact  = GetItemQualityColor(ITEM_QUALITY_ARTIFACT),  -- Artifact Purple (Epic)
      Legendary = GetItemQualityColor(ITEM_QUALITY_LEGENDARY), -- Legendary Gold (TheShit)
      Red       = ZO_ColorDef:New(1, 0, 0), -- Red
      Green     = ZO_ColorDef:New(0, 1, 0), -- green
      Yellow    = ZO_ColorDef:New(1, 1, 0), -- yellow
      Teal      = ZO_ColorDef:New(0, 1, 1), -- teal
   }
}
