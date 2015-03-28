local LAM = LibStub("LibAddonMenu-2.0")
if (not LAM) then return end
local SI = BankerShutUp.SI


local function setupBankerMenus()
    BankerShutUp.win.BankerShutUpMuter = CreateControlFromVirtual("BankerShutUpInteract", ZO_InteractWindowTargetAreaTitle, "ZO_DefaultButton")
    BankerShutUp.win.BankerShutUpMuter:SetParent(ZO_InteractWindowTargetAreaTitle)
    -- reopenTradeHistoryz:SetAnchor(RIGHT, RIGHT)
    BankerShutUp.win.BankerShutUpMuter:SetSimpleAnchorParent(TOPLEFT, -100)
    BankerShutUp.win.BankerShutUpMuter:SetText("Mute")
    BankerShutUp.win.BankerShutUpMuter:SetHandler("OnClicked", BankerShutUp.manualShutUp)
    --
    --
    --
    BankerShutUp.win.BankerShutUpUnMuter = CreateControlFromVirtual("BankerShutUpUnInteract", ZO_InteractWindowTargetAreaTitle, "ZO_DefaultButton")
    BankerShutUp.win.BankerShutUpUnMuter:SetParent(ZO_InteractWindowTargetAreaTitle)
    -- reopenTradeHistoryz:SetAnchor(RIGHT, RIGHT)
    BankerShutUp.win.BankerShutUpUnMuter:SetSimpleAnchorParent(TOPLEFT, -100)
    BankerShutUp.win.BankerShutUpUnMuter:SetText("Unmute")
    BankerShutUp.win.BankerShutUpUnMuter:SetHidden(true)
    BankerShutUp.win.BankerShutUpUnMuter:SetHandler("OnClicked", BankerShutUp.manualShutUpUnShutup)
    --
    --
    --
    BankerShutUp.win.BankerShutUpMuterLBL = WINDOW_MANAGER:CreateControl("BankerShutUpTitleHeader", BankerShutUp.win.BankerShutUpUnMuter, CT_LABEL)
    --BankerShutUp.win.BankerShutUpMuter:SetDimensions(200, 30)
    BankerShutUp.win.BankerShutUpMuterLBL:SetParent(BankerShutUp.win.BankerShutUpUnMuter)
    BankerShutUp.win.BankerShutUpMuterLBL:SetFont("ZoFontGameSmall")
    BankerShutUp.win.BankerShutUpMuterLBL:SetAlpha(0.3)
    BankerShutUp.win.BankerShutUpMuterLBL:SetSimpleAnchorParent(TOPLEFT, -20)
    BankerShutUp.win.BankerShutUpMuterLBL:SetText("Luminary BankerShutup")
end

function BankerShutUp.SetupOptionsMenu(index)
    setupBankerMenus()
    local panelData = {
        type = "panel",
        name = BankerShutUp.var.color.colArtifact .. "Luminary "
                .. BankerShutUp.var.color.colWhite .. "BankerShutUp",
    }

    LAM:RegisterAddonPanel("BankerAddonOptions", panelData)

    local optionsData = {
        [1] = {
            type = "header",
            name = "BankerShutUp",
            width = "half",
        },
        [2] = {
            type = "description",
            title = "\nBanker Options:",
            text = "Generic Bank Options."
        },
        [3] = {
            type = "checkbox",
            name = SI.get(SI.SHUTUP_BANKER),
            tooltip = SI.get(SI.SHUTUP_BANKER_INFO),
            getFunc = function() return mBankerShutUpSV.SHUTUP_BANKER end,
            setFunc = function(value) mBankerShutUpSV.SHUTUP_BANKER = value end,
        },
        [4] = {
            type = "checkbox",
            name = "Only the Banker",
            tooltip = "Mute only the banker, not other sounds",
            getFunc = function() return mBankerShutUpSV.OnlyTheBanker end,
            setFunc = function(value) mBankerShutUpSV.OnlyTheBanker = value end,
        },
        [5] = {
            type = "slider",
            name = "Banker Down",
            tooltip = SI.get(SI.HOWMUCHTOMUTEVOLUME_INFO),
            min = 0,
            max = 100,
            step = 1, --(optional)
            getFunc = function() return mBankerShutUpSV.VolumeControlToMute end,
            setFunc = function(value) mBankerShutUpSV.VolumeControlToMute = value end,
            width = "half", --or "half" (optional)
            default = 0, --(optional)
        },
        [6] = {
            type = "slider",
            name = "Banker Up",
            tooltip = SI.get(SI.HOWMUCHTORETURNVOLUME),
            min = 0,
            max = 100,
            step = 1, --(optional)
            getFunc = function() return mBankerShutUpSV.VolumeControlToRaise end,
            setFunc = function(value) mBankerShutUpSV.VolumeControlToRaise = value end,
            width = "half", --or "half" (optional)
            default = 80, --(optional)
        },
        [7] = {
            type = "description",
            title = "\nCrafting Options:",
            text = "Disable crafting tables (not vendors)"
        },

        --    ----------------------------- SHUTUP_WOODY

        [8] = {
            type = "checkbox",
            name = SI.get(SI.SHUTUP_WOODY),
            tooltip = SI.get(SI.SHUTUP_WOODY_INFO),
            getFunc = function() return mBankerShutUpSV.SHUTUP_WOODY end,
            setFunc = function(value) mBankerShutUpSV.SHUTUP_WOODY = value end,
        },

        --  ---------------------------- Black Smith
        [9] = {
            type = "checkbox",
            name = SI.get(SI.SHUTUP_BLACKSMITH),
            tooltip = SI.get(SI.SHUTUP_BLACKSMITH_INFO),
            getFunc = function() return mBankerShutUpSV.SHUTUP_BLACKSMITH end,
            setFunc = function(value) mBankerShutUpSV.SHUTUP_BLACKSMITH = value end,
        },

        --  ----------------------------- SHUTUP_COOK
        [10] = {
            type = "checkbox",
            name = SI.get(SI.SHUTUP_COOK),
            tooltip = SI.get(SI.SHUTUP_COOK_INFO),
            getFunc = function() return mBankerShutUpSV.SHUTUP_COOK end,
            setFunc = function(value) mBankerShutUpSV.SHUTUP_COOK = value end,
        },

        --  ----------------------------- SHUTUP_ENCHANTER
        [11] = {
            type = "checkbox",
            name = SI.get(SI.SHUTUP_ENCHANTER),
            tooltip = SI.get(SI.SHUTUP_ENCHANTER_INFO),
            getFunc = function() return mBankerShutUpSV.SHUTUP_ENCHANTER end,
            setFunc = function(value) mBankerShutUpSV.SHUTUP_ENCHANTER = value end,
        },


        --  ----------------------------- SHUTUP_CLOTH_INFO
        [12] = {
            type = "checkbox",
            name = SI.get(SI.SHUTUP_CLOTH),
            tooltip = SI.get(SI.SHUTUP_CLOTH_INFO),
            getFunc = function() return mBankerShutUpSV.SHUTUP_CLOTH end,
            setFunc = function(value) mBankerShutUpSV.SHUTUP_CLOTH = value end,
        },

        --  ----------------------------- SHUTUP_ALCH
        [13] = {
            type = "checkbox",
            name = SI.get(SI.SHUTUP_ALCH),
            tooltip = SI.get(SI.SHUTUP_ALCH_INFO),
            getFunc = function() return mBankerShutUpSV.SHUTUP_ALCH end,
            setFunc = function(value) mBankerShutUpSV.SHUTUP_ALCH = value end,
        },

        [14] = {
            type = "checkbox",
            name = "Hardcore shutup",
            tooltip = "This will mute all sound... might expand features on this.",
            getFunc = function() return mBankerShutUpSV.hardCoreShutUp end,
            setFunc = function(value) mBankerShutUpSV.hardCoreShutUp = value end,
        },

        [15] = {
            type = "button",
            name = "Force Reset Harcore shutup",
            tooltip = "Hardcore shut up ",
            func = function() mBankerShutUpSV.hardCoreShutUp = false
            SetSetting(SETTING_TYPE_AUDIO, 0, 1)
            end,
            width = "half",	--or "half" (optional)
            warning = "If for some reason you have no sound! HIT THIS BUTTON",	--(optional)
        },


        ----------------------- Volume Controls

        [16] = {
            type = "description",
            title = "\nVolume Controls: ",
            text = "How much should we mute the volumes?" .. BankerShutUp.var.color.colRed .. "\nExample: Down will mute when vendor is open. \nUp will restore to the volume you want.",
            warning = "test",
        },
        [17] = {
            type = "slider",
            name = "MasterVolume Down",
            tooltip = SI.get(SI.HOWMUCHTOMUTEVOLUME_INFO),
            min = 0,
            max = 100,
            step = 1, --(optional)
            getFunc = function() return mBankerShutUpSV.MasterVolumeMute end,
            setFunc = function(value) mBankerShutUpSV.MasterVolumeMute = value end,
            width = "half", --or "half" (optional)
            default = 0, --(optional)
        },
        [18] = {
            type = "slider",
            name = "MasterVolume Up",
            tooltip = SI.get(SI.HOWMUCHTORETURNVOLUME_INFO),
            min = 0,
            max = 100,
            step = 1, --(optional)
            getFunc = function() return mBankerShutUpSV.MasterVolume end,
            setFunc = function(value) mBankerShutUpSV.MasterVolume = value end,
            width = "half", --or "half" (optional)
            default = 80, --(optional)
        },



        [19] = {
            type = "submenu",
            name = "Volume Controls",
            tooltip = "Control the mute and unmute volume settings.", --(optional)
            controls = {
                --        LAM:AddEditBox(optionsPanel, "HowMuchShouldIReturnAmbience", "Return Ambience volume",
                --      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
                --      function () return mBankerShutUpSV.Ambience end, function(vol)mBankerShutUpSV.Ambience = vol end )




                [1] = {
                    type = "slider",
                    name = "Ambience Down",
                    tooltip = SI.get(SI.HOWMUCHTOMUTEVOLUME_INFO),
                    min = 0,
                    max = 100,
                    step = 1, --(optional)
                    getFunc = function() return mBankerShutUpSV.AmbienceMute end,
                    setFunc = function(value) mBankerShutUpSV.AmbienceMute = value end,
                    width = "half", --or "half" (optional)
                    default = 0, --(optional)
                },
                [2] = {
                    type = "slider",
                    name = "Ambience Up",
                    tooltip = SI.get(SI.HOWMUCHTORETURNVOLUME_INFO),
                    min = 0,
                    max = 100,
                    step = 1, --(optional)
                    getFunc = function() return mBankerShutUpSV.Ambience end,
                    setFunc = function(value) mBankerShutUpSV.Ambience = value end,
                    width = "half", --or "half" (optional)
                    default = 80, --(optional)
                },

                --Ambience Effetcs Footsteps Dialogue Interface
                --
                --
                --  LAM:AddEditBox(optionsPanel, "HowMuchShouldIMuteEffects", "",
                --      SI.get(SI.), false,
                --      function () return mBankerShutUpSV. end, function(vol)mBankerShutUpSV.EffectsMute = vol end )
                --

                [3] = {
                    type = "slider",
                    name = "Effects Down",
                    tooltip = SI.get(SI.HOWMUCHTOMUTEVOLUME_INFO),
                    min = 0,
                    max = 100,
                    step = 1, --(optional)
                    getFunc = function() return mBankerShutUpSV.EffectsMute end,
                    setFunc = function(value) mBankerShutUpSV.EffectsMute = value end,
                    width = "half", --or "half" (optional)
                    default = 0, --(optional)
                },
                [4] = {
                    type = "slider",
                    name = "Effects Up",
                    tooltip = SI.get(SI.HOWMUCHTORETURNVOLUME_INFO),
                    min = 0,
                    max = 100,
                    step = 1, --(optional)
                    getFunc = function() return mBankerShutUpSV.Effects end,
                    setFunc = function(value) mBankerShutUpSV.Effects = value end,
                    width = "half", --or "half" (optional)
                    default = 80, --(optional)
                },
                [5] = {
                    type = "slider",
                    name = "Footsteps Down",
                    tooltip = SI.get(SI.HOWMUCHTOMUTEVOLUME_INFO),
                    min = 0,
                    max = 100,
                    step = 1, --(optional)
                    getFunc = function() return mBankerShutUpSV.FootstepsMute end,
                    setFunc = function(value) mBankerShutUpSV.FootstepsMute = value end,
                    width = "half", --or "half" (optional)
                    default = 0, --(optional)
                },
                [6] = {
                    type = "slider",
                    name = "Footsteps Up",
                    tooltip = SI.get(SI.HOWMUCHTORETURNVOLUME_INFO),
                    min = 0,
                    max = 100,
                    step = 1, --(optional)
                    getFunc = function() return mBankerShutUpSV.Footsteps end,
                    setFunc = function(value) mBankerShutUpSV.Footsteps = value end,
                    width = "half", --or "half" (optional)
                    default = 80, --(optional)
                },

                --  LAM:AddEditBox(optionsPanel, "HowMuchShouldIMuteDialogue", "",
                --      SI.get(SI.), false,
                --      function () return mBankerShutUpSV.DialogueMute end, function(vol)mBankerShutUpSV. = vol end )
                --
                [7] = {
                    type = "slider",
                    name = "Dialogue Down",
                    tooltip = SI.get(SI.HOWMUCHTOMUTEVOLUME_INFO),
                    min = 0,
                    max = 100,
                    step = 1, --(optional)
                    getFunc = function() return mBankerShutUpSV.DialogueMute end,
                    setFunc = function(value) mBankerShutUpSV.DialogueMute = value end,
                    width = "half", --or "half" (optional)
                    default = 0, --(optional)
                },
                [8] = {
                    type = "slider",
                    name = "Dialogue Up",
                    tooltip = SI.get(SI.HOWMUCHTORETURNVOLUME_INFO),
                    min = 0,
                    max = 100,
                    step = 1, --(optional)
                    getFunc = function() return mBankerShutUpSV.Dialogue end,
                    setFunc = function(value) mBankerShutUpSV.Dialogue = value end,
                    width = "half", --or "half" (optional)
                    default = 80, --(optional)
                },

                --
                --  LAM:AddEditBox(optionsPanel, "HowMuchShouldIMuteInterface", "",
                --      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
                --      function () return mBankerShutUpSV. end, function(vol)mBankerShutUpSV.InterfaceMute = vol end )
                --

                [9] = {
                    type = "slider",
                    name = "Interface Down",
                    tooltip = SI.get(SI.HOWMUCHTOMUTEVOLUME_INFO),
                    min = 0,
                    max = 100,
                    step = 1, --(optional)
                    getFunc = function() return mBankerShutUpSV.InterfaceMute end,
                    setFunc = function(value) mBankerShutUpSV.InterfaceMute = value end,
                    width = "half", --or "half" (optional)
                    default = 0, --(optional)
                },
                [10] = {
                    type = "slider",
                    name = "Interface Up",
                    tooltip = SI.get(SI.HOWMUCHTORETURNVOLUME_INFO),
                    min = 0,
                    max = 100,
                    step = 1, --(optional)
                    getFunc = function() return mBankerShutUpSV.Interface end,
                    setFunc = function(value) mBankerShutUpSV.Interface = value end,
                    width = "half", --or "half" (optional)
                    default = 80, --(optional)
                },
            },
        },
    }


    LAM:RegisterOptionControls("BankerAddonOptions", optionsData)

    --  LAM:AddHeader(optionsPanel, "BankerInfoAboutLuminary", BankerShutUp.var.color.colArtifact .. SI.get(SI.APPNAME)
    --   .. BankerShutUp.var.color.colWhite.. SI.get(SI.BETA)..BankerShutUp.var.color.colRed ..SI.get(SI.BUGSQUASHER)..
    --   BankerShutUp.var.color.colWhite.. SI.get(SI.REPORTTHATSHITYO))
    --
    --  LAM:AddHeader(optionsPanel, "BankerILoveGoldDonations", BankerShutUp.var.color.colArtifact .. "\n\n\n\n".. SI.get(SI.ONLYGOOD)
    --  .. BankerShutUp.var.color.colLegendary .. SI.get(SI.DONATIONS) .. BankerShutUp.var.color.colWhite.. SI.get(SI.BADASS))
end

