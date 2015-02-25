
local function RegisterTheEventsPlease()
   -- ZO_Fishing_Initialize(ZO_FishingPanel)

    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_FISHING_LURE_CLEARED , LureCleared)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_FISHING_LURE_SET  , LureIsSet)

    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_CHATTER_BEGIN, pleaseDiableStart)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_CHATTER_END, pleaseDiableEnd)

    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_GAME_CAMERA_UI_MODE_CHANGED, DisableAlerts)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_INVENTORY_SINGLE_SLOT_UPDATE , FishMeNow)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_INVENTORY_ITEM_USED, TempisableAlerts)
    -- EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_ACTION_UPDATE_COOLDOWNS, TempisableAlerts)

    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_MAIL_OPEN_MAILBOX, pleaseDiableStart)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_OPEN_GUILD_BANK, pleaseDiableStart)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_OPEN_STORE, pleaseDiableStart)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_OPEN_TRADING_HOUSE, pleaseDiableStart)

    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe",EVENT_MAIL_CLOSE_MAILBOX, pleaseDiableEnd)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe",EVENT_CLOSE_GUILD_BANK, pleaseDiableEnd)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe",EVENT_CLOSE_STORE, pleaseDiableEnd)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe",EVENT_CLOSE_TRADING_HOUSE, pleaseDiableEnd)
    EVENT_MANAGER:UnregisterForEvent("Luminary_FishMe", EVENT_PLAYER_ACTIVATED)
end

function FSHOnAddOnLoaded(eventCode, addOnName)
  if ("Luminary_FishMe" ~= addOnName) then return end

  local Default = {
    ["FSH_Colorz"] = {},
    ["Enable_Fish_Bait"] = true,
    ["Enable_Reel_Alerts"] = true,
    ["Enable_Help_Dev"] = false
  }

  -- Load saved variables
  mSavedFHVars = ZO_SavedVars:New("Luminary_FishMe_SV", 1, nil, Default, nil )
  FSHsetup_display(2, "Fish_Setup_Display")

  EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_PLAYER_ACTIVATED, RegisterTheEventsPlease)


end
EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_ADD_ON_LOADED, FSHOnAddOnLoaded)