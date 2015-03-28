local LAM = LibStub("LibAddonMenu-2.0")

local panelData = {
    type = "panel",
    name = LABz.color.colArtifact .. "Luminary" .. LABz.color.colTeal .. " Action Bars",
    displayName = "Longer Window Title",
    author = "@awesomebilly",
    version = "1.6.5.0",
    slashCommand = "/lab", --(optional) will register a keybind to open to this panel
    registerForRefresh = true, --boolean (optional) (will refresh all options controls when a setting is changed and when the panel is shown)
    registerForDefaults = true, --boolean (optional) (will set all options controls back to default values)
}


local optionsTable = {
    [1] = {
        type = "header",
        name = LABz.color.colArtifact .. "Luminary" .. LABz.color.colTeal .. " Action Bar",
        width = "full", --or "half" (optional)
    },
    [2] = {
        type = "description",
        --title = "My Title",	--(optional)
        title = "Action Bar Options", --(optional)
        text = "To use this addon look at your weapon slot for the 'key'",
        width = "full", --or "half" (optional)
    },
    [3] = {
        type = "checkbox",
        name = "Hide Black Bar",
        tooltip = "Hide the black ultimate bar under the action bar?",
        getFunc = function() return LABzSV.HideBlackBar
        end,
        setFunc = function(value) LABzSV.HideBlackBar = value
        end,
        width = "half", --or "half" (optional)
        warning = "Will need to reload the UI.", --(optional)
    },
    [4] = {
        type = "checkbox",
        name = "Bind Slot Id to Center Top",
        tooltip = "This moves Q,1,2,3,4,5,6,R to the center/top of the action button.",
        getFunc = function() return LABzSV.CenterSlotIds
        end,
        setFunc = function(value) LABzSV.CenterSlotIds = value
        end,
        width = "half", --or "half" (optional)
    },
    [5] = {
        type = "checkbox",
        name = "Hide the weapon slot?",
        tooltip = "You can still swap weapons, just the icon is hidden.",
        getFunc = function() return LABzSV.HideWeaponSlot
        end,
        setFunc = function(value) LABzSV.HideWeaponSlot = value
        end,
        width = "half", --or "half" (optional)
    }
}

function LABz:SetupUI()
    LAM:RegisterAddonPanel("Luminary_ActionBars", panelData)
    LAM:RegisterOptionControls("Luminary_ActionBars", optionsTable)
end