LABz = {}
LABz = {
    appName = "Luminary_ActionBars",
    color = {
        colMagic = "|c2dc50e", -- Magic Green (Uncommon)
        colTrash = "|c777777", -- Trash Gray (Garbage)
        colYellow = "|cFFFF00", --yellow
        colArcane = "|c3689ef", -- Arcane Blue (Rare)
        colArtifact = "|c912be1", -- Epic (Epic)
        colTeal = "|c00FFFF", -- teal
        colWhite = "|cFFFFFF", -- white
        colRed = "|cFF0000", -- Red
        colLegendary = "|cd5b526", -- Legendary Gold (TheShit)
        colGreen = "|c00FF00" --green
    }
}


local function locker()
    btnActionBarUnlockTex:SetHidden(true)
    btnActionBarlockTex:SetHidden(false)

    ------ #3
    ActionButton3:SetMovable(false)
    ActionButton3:SetMouseEnabled(true)
    ActionButton3Button:SetMouseEnabled(true)

    ActionButton3ButtonText:SetMovable(false)
    ActionButton3ButtonText:SetMouseEnabled(false)


    ------ #4
    ActionButton4:SetMovable(false)
    ActionButton4:SetMouseEnabled(true)
    ActionButton4Button:SetMouseEnabled(true)



    ------ #5
    ActionButton5:SetMovable(false)
    ActionButton5:SetMouseEnabled(true)
    ActionButton5Button:SetMouseEnabled(true)


    ----- #6
    ActionButton6:SetMovable(false)
    ActionButton6:SetMouseEnabled(true)
    ActionButton6Button:SetMouseEnabled(true)


    ------ #7
    ActionButton7:SetMovable(false)
    ActionButton7:SetMouseEnabled(true)
    ActionButton7Button:SetMouseEnabled(true)


    --- - #8
    ActionButton8:SetMovable(false)
    ActionButton8:SetMouseEnabled(true)
    ActionButton8Button:SetMouseEnabled(true)


    ------ #9 which is actually 1
    ActionButton9:SetMovable(false)
    ActionButton9:SetMouseEnabled(true)
    ActionButton9Button:SetMouseEnabled(true)


    ZO_ActionBar1WeaponSwap:SetMovable(false)
    ZO_ActionBar1WeaponSwap:SetMouseEnabled(true)
end

local function unlocker()

    btnActionBarUnlockTex:SetHidden(false)
    btnActionBarUnlockTex:SetMovable(true)
    btnActionBarlockTex:SetHidden(true)


    ZO_ActionBar1KeybindBG:SetMovable(true)
    -- ZO_ContextualActionBar:SetHidden(true)
    ZO_ActionBar1KeybindBG:SetMouseEnabled(true)
    ZO_ActionBar1KeybindBG:SetResizeHandleSize(MOUSE_CURSOR_RESIZE_NS)

    -- ActionButton8UltimateBar:SetMouseEnabled(true)

    ------ #3
    ActionButton3:SetMovable(true)
    ActionButton3:SetMouseEnabled(true)
    --TODO make the buttons resizeable
    --    ActionButton3:SetResizeHandleSize(MOUSE_CURSOR_RESIZE_NS)
    ActionButton3Button:SetMouseEnabled(false)

    --   ActionButton3ButtonText:SetMovable(true)
    --   ActionButton3ButtonText:SetMouseEnabled(true)


    ------ #4
    ActionButton4:SetMovable(true)
    ActionButton4:SetMouseEnabled(true)
    ActionButton4Button:SetMouseEnabled(false)

    --   ActionButton4ButtonText:SetMovable(true)
    --   ActionButton4ButtonText:SetMouseEnabled(true)

    ------ #5
    ActionButton5:SetMovable(true)
    ActionButton5:SetMouseEnabled(true)
    ActionButton5Button:SetMouseEnabled(false)

    --   ActionButton5ButtonText:SetMovable(true)
    --  ActionButton5ButtonText:SetMouseEnabled(true)

    ----- #6
    ActionButton6:SetMovable(true)
    ActionButton6:SetMouseEnabled(true)
    ActionButton6Button:SetMouseEnabled(false)

    --   ActionButton6ButtonText:SetMovable(true)
    --   ActionButton6ButtonText:SetMouseEnabled(true)

    ------ #7
    ActionButton7:SetMovable(true)
    ActionButton7:SetMouseEnabled(true)
    ActionButton7Button:SetMouseEnabled(false)

    --  ActionButton7ButtonText:SetMovable(true)
    --ActionButton7ButtonText:SetMouseEnabled(true)

    ------ #8
    ActionButton8:SetMovable(true)
    ActionButton8:SetMouseEnabled(true)
    ActionButton8Button:SetMouseEnabled(false)

    -- ActionButton7ButtonText:SetMovable(true)
    --  ActionButton7ButtonText:SetMouseEnabled(true)


    ------ #9 which is actually 1
    ActionButton9:SetMovable(true)
    ActionButton9:SetMouseEnabled(true)
    ActionButton9Button:SetMouseEnabled(false)

    --  ActionButton9ButtonText:SetMovable(true)
    -- ActionButton9ButtonText:SetMouseEnabled(true)


    ZO_ActionBar1WeaponSwap:SetMovable(true)
    ZO_ActionBar1WeaponSwap:SetMouseEnabled(true)
end

local function moveActionBarSetup()
    EVENT_MANAGER:UnregisterForEvent(LABz.appName, EVENT_PLAYER_ACTIVATED)
    if LABzSV.HideWeaponSlot then
        btnActionBarUnlockTex = WINDOW_MANAGER:CreateControl(nil, ActionButton9, CT_TEXTURE)
        btnActionBarUnlockTex:SetAnchor(TOPLEFT, ActionButton9, TOPLEFT, -15, -15 )
        btnActionBarUnlockTex:SetDimensions(15, 15)
    else
    btnActionBarUnlockTex = WINDOW_MANAGER:CreateControl(nil, ZO_ActionBar1WeaponSwap, CT_TEXTURE)
    btnActionBarUnlockTex:SetAnchor(TOPLEFT, ZO_ActionBar1WeaponSwap, TOPLEFT, -10, - 10 )
        --LABzSV.UnlockX, LABzSV.UnlockY)
    btnActionBarUnlockTex:SetDimensions(15, 15)
    end


    btnActionBarUnlockTex:SetTexture("/esoui/art/miscellaneous/unlocked_up.dds")
    btnActionBarUnlockTex:SetTextureCoords(0, 1, 0, 1)
    btnActionBarUnlockTex:SetAlpha(1)


    btnActionBarUnlock = WINDOW_MANAGER:CreateControl(nil, btnActionBarUnlockTex, CT_BUTTON)
    btnActionBarUnlock:SetAnchorFill(btnActionBarUnlockTex)
    btnActionBarUnlock:SetDimensions(15, 15)
    -- btnActionBarUnlock.tooltipText = "Unlock the ActionBar"
    btnActionBarUnlock:SetHandler("OnClicked", function(self)
        locker()


        LABzSV.ABBG_WIDTH = ZO_ActionBar1KeybindBG:GetWidth()
        LABzSV.ABBG_HEIGHT = ZO_ActionBar1KeybindBG:GetHeight()
        LABzSV.ABBGX = ZO_ActionBar1KeybindBG:GetLeft()
        LABzSV.ABBGY = ZO_ActionBar1KeybindBG:GetTop()


        LABzSV.AB3X = math.floor(ActionButton3:GetLeft())
        LABzSV.AB3Y = math.floor(ActionButton3:GetTop())


        LABzSV.AB4X = math.floor(ActionButton4:GetLeft())
        LABzSV.AB4Y = math.floor(ActionButton4:GetTop())

        LABzSV.AB5X = math.floor(ActionButton5:GetLeft())
        LABzSV.AB5Y = math.floor(ActionButton5:GetTop())

        LABzSV.AB6X = math.floor(ActionButton6:GetLeft())
        LABzSV.AB6Y = math.floor(ActionButton6:GetTop())

        LABzSV.AB7X = math.floor(ActionButton7:GetLeft())
        LABzSV.AB7Y = math.floor(ActionButton7:GetTop())

        LABzSV.AB8X = math.floor(ActionButton8:GetLeft())
        LABzSV.AB8Y = math.floor(ActionButton8:GetTop())


        LABzSV.AB9X = math.floor(ActionButton9:GetLeft())
        LABzSV.AB9Y = math.floor(ActionButton9:GetTop())

        LABzSV.AB10X = math.floor(ZO_ActionBar1WeaponSwap:GetLeft())
        LABzSV.AB10Y = math.floor(ZO_ActionBar1WeaponSwap:GetTop())

        LABzSV.UnlockX = math.floor(btnActionBarUnlockTex:GetLeft())
        LABzSV.UnlockY = math.floor(btnActionBarUnlockTex:GetTop())


        d("Locked, Changes have been saved.")
    end)

    btnActionBarUnlockTex:SetHidden(true)


    if LABzSV.HideWeaponSlot then
        btnActionBarlockTex = WINDOW_MANAGER:CreateControl(nil, ActionButton9, CT_TEXTURE)
        btnActionBarlockTex:SetAnchor(TOPLEFT, ActionButton9, TOPLEFT, -15, - 15 )
        btnActionBarlockTex:SetDimensions(15, 15)
    else
        btnActionBarlockTex = WINDOW_MANAGER:CreateControl(nil, ZO_ActionBar1WeaponSwap, CT_TEXTURE)
        btnActionBarlockTex:SetAnchor(TOPLEFT, ZO_ActionBar1WeaponSwap, TOPLEFT, -10, - 10 )
        --LABzSV.UnlockX, LABzSV.UnlockY)
        btnActionBarlockTex:SetDimensions(15, 15)
    end
    btnActionBarlockTex:SetTexture("/esoui/art/miscellaneous/locked_down.dds")
    btnActionBarlockTex:SetTextureCoords(0, 1, 0, 1)
    btnActionBarlockTex:SetAlpha(1)



    btnActionBarlock = WINDOW_MANAGER:CreateControl(nil, btnActionBarlockTex, CT_BUTTON)
    btnActionBarlock:SetAnchorFill(btnActionBarUnlockTex)
    btnActionBarlock:SetDimensions(15, 15)
    --  btnActionBarlock.tooltipText = "Unlock the ActionBar"
    btnActionBarlock:SetHandler("OnClicked", function(self)
        unlocker()
        d("Make sure to lock when you're finished.")
    end)

    btnActionBarlockTex:SetHidden(false)

    if LABzSV.HideBlackBar then
        ZO_ActionBar1KeybindBG:SetHidden(true)
        ZO_ActionBar1KeybindBG:SetAlpha(0)
    else
        ZO_ActionBar1KeybindBG:ClearAnchors()
        ZO_ActionBar1KeybindBG:SetDimensions(LABzSV.ABBG_WIDTH, LABzSV.ABBG_HEIGHT)
        ZO_ActionBar1KeybindBG:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LABzSV.ABBGX, LABzSV.ABBGY)
        ZO_ActionBar1KeybindBG:SetHidden(false)
        ZO_ActionBar1KeybindBG:SetAlpha(1)
    end


    ActionButton3:ClearAnchors()
    ActionButton3:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LABzSV.AB3X, LABzSV.AB3Y)
    --  ActionButton3BG:SetHidden(true)


    ActionButton4:ClearAnchors()
    ActionButton4:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LABzSV.AB4X, LABzSV.AB4Y)


    ActionButton5:ClearAnchors()
    ActionButton5:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LABzSV.AB5X, LABzSV.AB5Y)


    ActionButton6:ClearAnchors()
    ActionButton6:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LABzSV.AB6X, LABzSV.AB6Y)


    ActionButton7:ClearAnchors()
    ActionButton7:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LABzSV.AB7X, LABzSV.AB7Y)


    ActionButton8:ClearAnchors()
    ActionButton8:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LABzSV.AB8X, LABzSV.AB8Y)


    ActionButton9:ClearAnchors()
    ActionButton9:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LABzSV.AB9X, LABzSV.AB9Y)

    ZO_PlayerToPlayerAreaPromptContainer:ClearAnchors()
    ZO_PlayerToPlayerAreaPromptContainer:SetAnchor(BOTTOM, ZO_PlayerToPlayerArea, BOTTOM, 0, -550)

    if LABzSV.CenterSlotIds then
        --   ActionButton9:ClearAnchors()
        --  ActionButton9:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LABzSV.AB9X, LABzSV.AB9Y)

        ActionButton3ButtonText:ClearAnchors()
        ActionButton3ButtonText:SetAnchorFill(ActionButton3)
        ActionButton3ButtonText:SetMouseEnabled(false)
        ActionButton3ButtonText:SetMovable(false)

        ActionButton4ButtonText:ClearAnchors()
        ActionButton4ButtonText:SetAnchorFill(ActionButton4)
        ActionButton4ButtonText:SetMouseEnabled(false)
        ActionButton4ButtonText:SetMovable(false)

        ActionButton5ButtonText:ClearAnchors()
        ActionButton5ButtonText:SetAnchorFill(ActionButton5)
        ActionButton5ButtonText:SetMouseEnabled(false)
        ActionButton5ButtonText:SetMovable(false)

        ActionButton6ButtonText:ClearAnchors()
        ActionButton6ButtonText:SetAnchorFill(ActionButton6)
        ActionButton6ButtonText:SetMouseEnabled(false)
        ActionButton6ButtonText:SetMovable(false)

        ActionButton7ButtonText:ClearAnchors()
        ActionButton7ButtonText:SetAnchorFill(ActionButton7)
        ActionButton7ButtonText:SetMouseEnabled(false)
        ActionButton7ButtonText:SetMovable(false)

        ActionButton8ButtonText:ClearAnchors()
        ActionButton8ButtonText:SetAnchorFill(ActionButton8)
        ActionButton8ButtonText:SetMouseEnabled(false)
        ActionButton8ButtonText:SetMovable(false)

        ActionButton9ButtonText:ClearAnchors()
        ActionButton9ButtonText:SetAnchorFill(ActionButton9)
        -- ActionButton9ButtonText:SetText("Hi")
        ActionButton9ButtonText:SetMouseEnabled(false)
        ActionButton9ButtonText:SetMovable(false)
    end

    if LABzSV.HideWeaponSlot then
        ZO_ActionBar1WeaponSwap:SetAlpha(0)
    else
        ZO_ActionBar1WeaponSwap:ClearAnchors()
        ZO_ActionBar1WeaponSwap:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, LABzSV.AB10X, LABzSV.AB10Y)
    end
end


local function OnAddOnLoaded(eventCode, addOnName)
    if (LABz.appName ~= addOnName) then return end


    local Default = {
        ['ABBG_WIDTH'] = ZO_ActionBar1KeybindBG:GetWidth(),
        ['ABBG_HEIGHT'] = ZO_ActionBar1KeybindBG:GetHeight(),
        ['ABBGX'] = ZO_ActionBar1KeybindBG:GetLeft(),
        ['ABBGY'] = ZO_ActionBar1KeybindBG:GetTop(),
        ['AB3X'] = math.floor(ActionButton3:GetLeft()),
        ['AB3Y'] = math.floor(ActionButton3:GetTop()),
        ['AB4X'] = math.floor(ActionButton4:GetLeft()),
        ['AB4Y'] = math.floor(ActionButton4:GetTop()),
        ['AB5X'] = math.floor(ActionButton5:GetLeft()),
        ['AB5Y'] = math.floor(ActionButton5:GetTop()),
        ['AB6X'] = math.floor(ActionButton6:GetLeft()),
        ['AB6Y'] = math.floor(ActionButton6:GetTop()),
        ['AB7X'] = math.floor(ActionButton7:GetLeft()),
        ['AB7Y'] = math.floor(ActionButton7:GetTop()),
        ['AB8X'] = math.floor(ActionButton8:GetLeft()),
        ['AB8Y'] = math.floor(ActionButton8:GetTop()),
        ['AB9X'] = math.floor(ActionButton9:GetLeft()),
        ['AB9Y'] = math.floor(ActionButton9:GetTop()),
        ['AB10X'] = math.floor(ZO_ActionBar1WeaponSwap:GetLeft()),
        ['AB10Y'] = math.floor(ZO_ActionBar1WeaponSwap:GetTop()),
        ['AB3XBtn'] = 0,
        ['AB3YBtn'] = 0,
        ['AB4XBtn'] = 0,
        ['AB4YBtn'] = 0,
        ['AB5XBtn'] = 0,
        ['AB5YBtn'] = 0,
        ['AB6XBtn'] = 0,
        ['AB6YBtn'] = 0,
        ['AB7XBtn'] = 0,
        ['AB7YBtn'] = 0,
        ['AB8XBtn'] = 0,
        ['AB8YBtn'] = 0,
        ['AB9XBtn'] = 0,
        ['AB9YBtn'] = 0,
        ['HideBlackBar'] = false,
        ['CenterSlotIds'] = false,
        ["HideWeaponSlot"] = false,
        ["UnlockX"] = ActionButton3:GetLeft() - 50,
        ["UnlockY"] = ActionButton3:GetTop() - 50,
        ["LockX"] = ActionButton3:GetLeft() - 50,
        ["LockY"] = ActionButton3:GetTop() - 10
        --  ['AB10XBtn'] = math.floor(ZO_ActionBar1WeaponSwap:GetLeft()),
        --  ['AB10YBtn'] = math.floor(ZO_ActionBar1WeaponSwap:GetTop()),
    }
    --    LABzSV.HideWeaponSlot
    LABzSV = ZO_SavedVars:NewAccountWide("Luminary_ActionBars_SV", 10, nil, Default, nil)

    LABz.SetupUI()
    EVENT_MANAGER:RegisterForEvent(LABz.appName, EVENT_PLAYER_ACTIVATED, moveActionBarSetup)
end

EVENT_MANAGER:RegisterForEvent(LABz.appName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
