local SI = FishMe.SI
local Config = FishMe.Config
local col = FishMe.Config.colors
local SavedVars

local fishType = {
    guts = 2,
    insect = 4,
    worms = 5,
    minnow = 8,
    fishroe = 9,
    shad = 6,
    crawlers = 3,
    chub = 7,
}

local function alertUser(type, where, what)
    local message = col.Yellow:Colorize(type) .. SI.get(SI.AREUSEDIN) .. col.Teal:Colorize(where) .. what 
    CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_EVENT_LARGE_TEXT, SOUNDS.BOOK_ACQUIRED, message)
end

local function LureIsSet(_, index)
    if SavedVars.Enable_Fish_Bait then
        if index == fishType.guts then
            alertUser(SI.get(SI.GUTS), SI.get(SI.LAKES), SI.get(SI.GUTSMSG))
        elseif index == fishType.insect then
            alertUser(SI.get(SI.INSECTS), SI.get(SI.RIVERS), SI.get(SI.INSECTSMSG))
        elseif index == fishType.worms then
            alertUser(SI.get(SI.WORMS), SI.get(SI.SEA), SI.get(SI.WORMSMSG))
        elseif index == fishType.minnow then
            alertUser(SI.get(SI.MINNOW), SI.get(SI.LAKES), SI.get(SI.MINNOWMSG))
        elseif index == fishType.fishroe then
            alertUser(SI.get(SI.FISHROE), SI.get(SI.FOULWATER), SI.get(SI.FISHROEMSG))
        elseif index == fishType.chub then
            alertUser(SI.get(SI.CHUB), SI.get(SI.SEA), SI.get(SI.CHUBMSG))
        elseif index == fishType.crawlers then
            alertUser(SI.get(SI.CRAWLERS), SI.get(SI.FOULWATER), SI.get(SI.CRAWLERSMSG))
        elseif index == fishType.shad then
            alertUser(SI.get(SI.SHAD), SI.get(SI.RIVERS), SI.get(SI.SHADMSG))
--         elseif index == 1 then
--             alertUser("Simple Bait", SI.get(SI.RIVERS), SI.get(SI.SHADMSG))
--         else
        end
    end
end

local function LureCleared()
    if Config.allowAlert then
        zo_callLater(function() CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_EVENT_LARGE_TEXT, SOUNDS.BOOK_ACQUIRED, SI.get(SI.MOREBAIT)) end, 1500)
    end
end

local function pleaseDiableStart(index)
    Config.allowAlert = false
end

local function pleaseDiableEnd()
    Config.allowAlert = true
end

local function DisableAlerts()
    if Config.addonIsLoaded then
        if not SCENE_MANAGER:IsShowing("hud") then
            Config.tempDisableAlerts = true
        elseif SCENE_MANAGER:IsInUIMode() then
            Config.tempDisableAlerts = true
        else
            Config.tempDisableAlerts = false
        end
    end
end

local function ReEnableAlertS()
    Config.tempDisableAlerts = false
end

local function TempDisableAlerts()
    Config.tempDisableAlerts = true
    zo_callLater(function() ReEnableAlertS() end, 1500)
end

local function FishMeNow(bagId, slotId, isNewItem, itemSoundCategory, updateReason)
    if SavedVars.Enable_Reel_Alerts then -- allow user to disable reel in alerts.
        local action, name = GetGameCameraInteractableActionInfo()
        if action == GetString(SI_GAMECAMERAACTIONTYPE17) and name == SI.get(SI.FISHINGHOLE) then
            if not Config.tempDisableAlerts then
                if Config.allowAlert then
                    if not SCENE_MANAGER:IsInUIMode() then
                        if not itemSoundCategory then
                            CENTER_SCREEN_ANNOUNCE:AddMessage(0, CSA_EVENT_LARGE_TEXT, SOUNDS.BOOK_ACQUIRED, SI.get(SI.REELIN))
                            --d(SI.get(SI.REELIN))
                        end
                    end
                end
            end
        end
    end
end

local function SetupOptionsMenu()
   local LAM = LibStub( "LibAddonMenu-2.0", true )
   if ( not LAM ) then return end

   local panelData = {
      type = "panel",
      name = "Luminary FishMe",
      displayName = col.Artifact:Colorize("Luminary ") .. col.Magic:Colorize("FishMe"),
      author = "awesomebilly",
      version = FishMe.Config.Version,
      slashCommand = "/fishme",
      registerForRefresh = true 
   }
   local optionsData = {
      {
         type = "header",
         name = col.Artifact:Colorize("Luminary ") .. SI.get(SI.FISHOPTIONS),
      },
      {
         type = "checkbox",
         name = SI.get(SI.RECEIVEBAITALERTS),
         tooltip = SI.get(SI.BAITMSG),
         getFunc = function() return SavedVars.Enable_Fish_Bait end,
         setFunc = function(val) SavedVars.Enable_Fish_Bait = val end,
      },
      {
         type = "checkbox",
         name = SI.get(SI.RECEIVEREELALERTS),
         tooltip = SI.get(SI.REELMSG),
         getFunc = function() return SavedVars.Enable_Reel_Alerts end,
         setFunc = function(val) SavedVars.Enable_Reel_Alerts = val end,
      },
      {
         type = "description",
         title = panelData.displayName .. SI.get(SI.BETA) .. SI.get(SI.REPORTTHATSHITYO),  
         text = col.Artifact:Colorize("\n\n\n\n".. SI.get(SI.ONLYGOOD)) .. col.Legendary:Colorize(SI.get(SI.DONATIONS)) .. SI.get(SI.BADASS), 
      },
   }
   LAM:RegisterAddonPanel("Luminary_FishMe_Options_Settings", panelData) 
   LAM:RegisterOptionControls("Luminary_FishMe_Options_Settings", optionsData)
end

local function RegisterTheEventsPlease()
   -- ZO_Fishing_Initialize(ZO_FishingPanel)

    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_FISHING_LURE_CLEARED, LureCleared)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_FISHING_LURE_SET, LureIsSet)

    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_CHATTER_BEGIN, pleaseDiableStart)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_CHATTER_END, pleaseDiableEnd)

    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_GAME_CAMERA_UI_MODE_CHANGED, DisableAlerts)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, FishMeNow)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_INVENTORY_ITEM_USED, TempDisableAlerts)
    -- EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_ACTION_UPDATE_COOLDOWNS, TempisableAlerts)

    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_MAIL_OPEN_MAILBOX, pleaseDiableStart)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_OPEN_GUILD_BANK, pleaseDiableStart)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_OPEN_STORE, pleaseDiableStart)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_OPEN_TRADING_HOUSE, pleaseDiableStart)

    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_MAIL_CLOSE_MAILBOX, pleaseDiableEnd)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_CLOSE_GUILD_BANK, pleaseDiableEnd)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_CLOSE_STORE, pleaseDiableEnd)
    EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_CLOSE_TRADING_HOUSE, pleaseDiableEnd)

    EVENT_MANAGER:UnregisterForEvent("Luminary_FishMe", EVENT_PLAYER_ACTIVATED)
end

local function OnAddOnLoaded(eventCode, addOnName)
   if ("Luminary_FishMe" ~= addOnName) then return end

   -- Load saved variables
   FishMe.SavedVars = ZO_SavedVars:New("Luminary_FishMe_SV", 1, nil, FishMe.DefaultVars)
   SavedVars = FishMe.SavedVars 

   SetupOptionsMenu()

   EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_PLAYER_ACTIVATED, RegisterTheEventsPlease)
end

EVENT_MANAGER:RegisterForEvent("Luminary_FishMe", EVENT_ADD_ON_LOADED, OnAddOnLoaded)
