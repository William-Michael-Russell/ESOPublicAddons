local LL = LibStub('LibLuminary-2.0', 1)
if (not LL) then return end
--
--



local ADDON_NAME = "LuminaryLib"
local ROW_HEIGHT = 30

function LL:ClearList()
    --d("Hello")
    d(LUMINARY_LIB:fucker())
    d(self:TestCases())
    d("Whats Up")
end

local function DoSomething() d("whats ups") end




local function OnAddOnLoaded(eventCode, addOnName)
    if (ADDON_NAME ~= addOnName) then return end

    local config = {
        appName = ADDON_NAME,
        height = 300,
        width = 250
    }


    LUMINARY_LIB = LL:New(config)
    LUMINARY_LIB:Initialize()


    EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_PLAYER_ACTIVATED, DoSomething)
    -- EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_CRAFTING_STATION_INTERACT,  LUMINARY_LIB:ClearList())
end


EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddOnLoaded)

SLASH_COMMANDS["/foo"] = function(extra)
    LUMINARY_LIB:ClearList()
end

SLASH_COMMANDS["/up"] = function(extra)
    LUMINARY_LIB:UpdateScrollList()
end


