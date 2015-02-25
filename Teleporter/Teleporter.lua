local SI = Teleporter.SI


function Teleporter.TargetUnavailableToPortal()
    d(SI.get(SI.TELE_UNABLE_TO_PORTAL))
    local toonsLevel = GetUnitLevel("player")
    if toonsLevel < 50 then
        d("If you get a lot of portal issues, try disabling level 50's in the settings menu")
    end
end


local function alertTeleporterLoaded()

 --   d(Teleporter.var.color.colArcane .. SI.get(SI.TELEWELCOMEMSG))
    Teleporter.CheckGuildMemeberStatus()
    Teleporter.var.playerName = GetUnitName("player")
    EVENT_MANAGER:UnregisterForEvent(Teleporter.var.appName, EVENT_PLAYER_ACTIVATED)

end


function Teleporter.PortalHandlerMapOpen(index1, index2)
    if SCENE_MANAGER:IsShowing("worldMap") then
        if mTeleSavedVars.AutoOpenMap then
            Teleporter.win.Main_Control:SetHidden(false)
        else
            Teleporter.win.Main_Control:SetHidden(true)
            Teleporter.win.MapOpen:SetHidden(false)
        end

     else
        Teleporter.win.Main_Control:SetHidden(true)
    end
end

function Teleporter.OpenTeleporter()
    Teleporter.win.Main_Control:SetHidden(false)
end

function Teleporter.HideUIz()
    Teleporter.win.Main_Control:SetHidden(true)
end

function Teleporter.simpleHide()
    Teleporter.win.Main_Control:SetHidden(true)
end

function Teleporter.SocialError(int, error)
    if error == 55 then
        d(SI.get(SI.TELE_ERROR))
    elseif error == 36 then
        d(SI.get(SI.TELE_ERROR))
    end
    -- = 55 social option
    --  36 generic can't jump'
end

function Teleporter.PortalHandlerMapClose(index1, index2)
    --    SCENE_MANAGER.currentScene.name
    if not SCENE_MANAGER:IsShowing("worldMap") then
        Teleporter.win.Main_Control:SetHidden(true)
    end
end

function Teleporter.PlayerInitAndReady()
    Teleporter.CheckGuildMemeberStatus()
    zo_callLater(function() alertTeleporterLoaded() end, 3000)
end


local function OnAddOnLoaded(eventCode, addOnName)
    if (Teleporter.var.appName ~= addOnName) then return end
    Teleporter.var.isAddonLoaded = true

    local Default = {
        ["logV"] = true,
        ["logD"] = true,
        ["LogE"] = true,
        ["TH_x"] = 30,
        ["TH_y"] = 150,
        ["loadMessageDelay"] = 15,
        ["ShowOnMapOpen"] = true,
        ["AlertOnTeleportStart"] = true,
        ["FilterCloserToLevel"] = false,
        ["AutoPortFreq"]  = 45,
        ["AutoOpenMap"] = true
    }

    mTeleSavedVars = ZO_SavedVars:New("Teleporter_SV", 2, nil, Default, nil)
    TeleporterSetupUI(addOnName)
    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_GRAVEYARD_USAGE_FAILURE, Teleporter.TargetUnavailableToPortal)

    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_PLAYER_ACTIVATED, Teleporter.PlayerInitAndReady)
    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_ACTION_LAYER_PUSHED, Teleporter.PortalHandlerMapOpen)
    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_ACTION_LAYER_POPPED, Teleporter.PortalHandlerMapClose)

    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName,  EVENT_MAIL_OPEN_MAILBOX, Teleporter.simpleHide)
    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_MAIL_OPEN_MAILBOX, Teleporter.simpleHide)
    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_OPEN_GUILD_BANK, Teleporter.simpleHide)
    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_OPEN_STORE, Teleporter.simpleHide)
    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_OPEN_TRADING_HOUSE, Teleporter.simpleHide)
    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_CHATTER_BEGIN, Teleporter.simpleHide)
    EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_SOCIAL_ERROR, Teleporter.SocialError)




end

EVENT_MANAGER:RegisterForEvent(Teleporter.var.appName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

--- - How to make a slash command!
SLASH_COMMANDS["/Teleporter"] = ImaSlashCommand