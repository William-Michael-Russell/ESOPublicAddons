-- Guild Manager @awesomebilly (Luminary Guild)
--local LAM = LibStub:NewLibrary("LibAddonMenu-1.0")



local SI = mFSHConfig.SI

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

local col = getFSColor()


local function alertUser(type, where, what)
    CENTER_SCREEN_ANNOUNCE:AddMessage(EVENT_SKILL_RANK_UPDATE,
        CSA_EVENT_LARGE_TEXT, SOUNDS.BOOK_ACQUIRED,
        mFSHConfig.col.colYellow .. type .. mFSHConfig.col.colWhite .. SI.get(SI.AREUSEDIN) .. mFSHConfig.col.colTeal .. where
                .. mFSHConfig.col.colWhite .. what)
end


function LureIsSet(someid, index)
    if mSavedFHVars.Enable_Fish_Bait then
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

        elseif index == 1 then
            --   alertUser("Simple Bait", SI.get(SI.RIVERS), SI.get(SI.SHADMSG))
        else
        end
    end
end

function pleaseDiableStart(index)


    mFSHConfig.allowAlert = false
end

function pleaseDiableEnd()
    mFSHConfig.allowAlert = true
end

local function HelpAPoorFisherMan(string, reason)
    if mSavedFHVars.Enable_Help_Dev then
        d(string .. " " .. reason)
    end
end

function LureCleared()
    zo_callLater(function() CENTER_SCREEN_ANNOUNCE:AddMessage(EVENT_SKILL_RANK_UPDATE, CSA_EVENT_LARGE_TEXT, SOUNDS.BOOK_ACQUIRED, SI.get(SI.MOREBAIT))
    end, 1500)
end

function DisableAlerts()
    -- d(FISHING.menu.entryPool)
    --  d(FISHING.menu.isInteracting)
    if mFSHConfig.addonIsLoaded then
        --    SCENE_MANAGER.currentScene.name
        -- if SCENE_MANAGER.currentScene.name == nil then return end
        if SCENE_MANAGER.currentScene.name ~= "hud" then
            mFSHConfig.tempDisableAlerts = true
        elseif SCENE_MANAGER:IsInUIMode() then
            mFSHConfig.tempDisableAlerts = true
        else
            mFSHConfig.tempDisableAlerts = false
        end
    end
end

local function ReEnableAlertS()
    mFSHConfig.tempDisableAlerts = false
end

function TempisableAlerts()
    mFSHConfig.tempDisableAlerts = true
    zo_callLater(function() ReEnableAlertS() end, 1500)
end



function FishMeNow(bagId, slotId, isNewItesam, itemSoundCategory, updateReason)
    local e = {}

    e.a, e.b, e.c, e.d, e.f, e.g = GetGameCameraInteractableActionInfo()
    if mSavedFHVars.Enable_Reel_Alerts then -- allow user to disable reel in alerts.
        HelpAPoorFisherMan("|cFF0000 Missing Reel In message? \n send @Awesomebilly (NA-Server) this number\n",
            "Missing - Update Reason: " .. updateReason)

        if (e.a == "Reel In" and e.b == "Fishing Hole") then

            if not mFSHConfig.tempDisableAlerts then
                if mFSHConfig.allowAlert then
                    if not SCENE_MANAGER:IsInUIMode() then


                        if not itemSoundCategory then
                            --   d("should alert")
                            HelpAPoorFisherMan("|cFF0000 Missing Reel In message? \n send @awesomebilly (NA-Server) this number\n",
                                "Missing - Update Reason: " .. updateReason)

                            CENTER_SCREEN_ANNOUNCE:AddMessage(EVENT_SKILL_RANK_UPDATE, CSA_EVENT_LARGE_TEXT, SOUNDS.BOOK_ACQUIRED, SI.get(SI.REELIN))
                            d(SI.get(SI.REELIN))
                        end
                    end
                end
            end
        end
    end
end


local showLoadMSg = true
function FishMeUpdate()
    if showLoadMSg then
        if BufferReached("FishMeLoaded", 7) then
            mFSHConfig.addonIsLoaded = true
            d("|c912be1Luminary |c00FFFFFishMe \n" .. SI.get(SI.SHESABITER))
            showLoadMSg = false
        end
    end
end
