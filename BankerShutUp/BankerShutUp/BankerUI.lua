local LAM = LibStub( 'LibAddonMenu-1.0' )
if ( not LAM ) then return end
local SI = BankerShutUp.SI

function BankerShutUp.SetupOptionsMenu(index)



    BankerShutUp.win.BankerShutUpMuter = CreateControlFromVirtual("BankerShutUpInteract", ZO_InteractWindowTargetAreaTitle, "ZO_DefaultButton")
    BankerShutUp.win.BankerShutUpMuter:SetParent(ZO_InteractWindowTargetAreaTitle)
   -- reopenTradeHistoryz:SetAnchor(RIGHT, RIGHT)
    BankerShutUp.win.BankerShutUpMuter:SetSimpleAnchorParent(TOPLEFT,-100)
    BankerShutUp.win.BankerShutUpMuter:SetText("Mute")
    BankerShutUp.win.BankerShutUpMuter:SetHandler("OnClicked", BankerShutUp.manualShutUp)



    BankerShutUp.win.BankerShutUpUnMuter = CreateControlFromVirtual("BankerShutUpUnInteract", ZO_InteractWindowTargetAreaTitle, "ZO_DefaultButton")
    BankerShutUp.win.BankerShutUpUnMuter:SetParent(ZO_InteractWindowTargetAreaTitle)
    -- reopenTradeHistoryz:SetAnchor(RIGHT, RIGHT)
    BankerShutUp.win.BankerShutUpUnMuter:SetSimpleAnchorParent(TOPLEFT,-100)
    BankerShutUp.win.BankerShutUpUnMuter:SetText("Unmute")
    BankerShutUp.win.BankerShutUpUnMuter:SetHidden(true)
    BankerShutUp.win.BankerShutUpUnMuter:SetHandler("OnClicked", BankerShutUp.manualShutUpUnShutup)



    BankerShutUp.win.BankerShutUpMuterLBL = WINDOW_MANAGER:CreateControl("BankerShutUpTitleHeader", BankerShutUp.win.BankerShutUpUnMuter, CT_LABEL)
    --BankerShutUp.win.BankerShutUpMuter:SetDimensions(200, 30)
    BankerShutUp.win.BankerShutUpMuterLBL:SetParent(BankerShutUp.win.BankerShutUpUnMuter)
    BankerShutUp.win.BankerShutUpMuterLBL:SetFont("ZoFontGameSmall")
    BankerShutUp.win.BankerShutUpMuterLBL:SetAlpha(0.3)
    BankerShutUp.win.BankerShutUpMuterLBL:SetSimpleAnchorParent(TOPLEFT,-20)
    BankerShutUp.win.BankerShutUpMuterLBL:SetText("Luminary BankerShutup")



  local optionsPanel = LAM:CreateControlPanel("Luminary_BankerShutUp", BankerShutUp.var.color.colArtifact .. "Luminary"
          .. BankerShutUp.var.color.colMagic .. "\nBanker Shutup")

  LAM:AddHeader(optionsPanel, "Luminary_BankerShutUp_Options",  BankerShutUp.var.color.colArtifact .."Luminary "
          .. BankerShutUp.var.color.colWhite .. "Banker Options")


  LAM:AddHeader(optionsPanel, "Luminary_Banker_WhatITDoes",  "The Crafting Options disables crafting tables not vendors ")

---------------------------- Banker
  LAM:AddCheckbox(optionsPanel, "_ShutupShutTheBankerUp", SI.get(SI.SHUTUP_BANKER), SI.get(SI.SHUTUP_BANKER_INFO),
    function() return mBankerShutUpSV.SHUTUP_BANKER end,
    function(val) mBankerShutUpSV.SHUTUP_BANKER = val
    end)

  LAM:AddCheckbox(optionsPanel, "_OnlyTheBanker", "Only the Banker", "Mute only the banker, not other sounds",
      function() return mBankerShutUpSV.OnlyTheBanker end,
      function(val) mBankerShutUpSV.OnlyTheBanker = val
      end)

  ---------------------------- Black Smith
      LAM:AddCheckbox(optionsPanel, "_ShutupShutTheBSUp", SI.get(SI.SHUTUP_BLACKSMITH), SI.get(SI.SHUTUP_BLACKSMITH_INFO),
    function() return mBankerShutUpSV.SHUTUP_BLACKSMITH end,
    function(val) mBankerShutUpSV.SHUTUP_BLACKSMITH = val
    end)

    ----------------------------- SHUTUP_WOODY
    LAM:AddCheckbox(optionsPanel, "_ShutupSHUTUP_WOODY", SI.get(SI.SHUTUP_WOODY), SI.get(SI.SHUTUP_WOODY_INFO),
    function() return mBankerShutUpSV.SHUTUP_WOODY end,
    function(val) mBankerShutUpSV.SHUTUP_WOODY = val
    end)

  ----------------------------- SHUTUP_COOK
  LAM:AddCheckbox(optionsPanel, "_ShutupSHUTUP_COOK", SI.get(SI.SHUTUP_COOK), SI.get(SI.SHUTUP_COOK_INFO),
      function() return mBankerShutUpSV.SHUTUP_COOK end,
      function(val) mBankerShutUpSV.SHUTUP_COOK = val
      end)

  ----------------------------- SHUTUP_ENCHANTER
  LAM:AddCheckbox(optionsPanel, "_ShutupSHUTUP_ENCHANTER", SI.get(SI.SHUTUP_ENCHANTER), SI.get(SI.SHUTUP_ENCHANTER_INFO),
      function() return mBankerShutUpSV.SHUTUP_ENCHANTER end,
      function(val) mBankerShutUpSV.SHUTUP_ENCHANTER = val
      end)

  ----------------------------- SHUTUP_CLOTH_INFO
  LAM:AddCheckbox(optionsPanel, "_ShutupSHUTUP_CLOTH", SI.get(SI.SHUTUP_CLOTH), SI.get(SI.SHUTUP_CLOTH_INFO),
      function() return mBankerShutUpSV.SHUTUP_CLOTH end,
      function(val) mBankerShutUpSV.SHUTUP_CLOTH = val
      end)


  ----------------------------- SHUTUP_ALCH
  LAM:AddCheckbox(optionsPanel, "_ShutupSHUTUP_ALCH", SI.get(SI.SHUTUP_ALCH), SI.get(SI.SHUTUP_ALCH_INFO),
      function() return mBankerShutUpSV.SHUTUP_ALCH end,
      function(val) mBankerShutUpSV.SHUTUP_ALCH = val
      end)




  LAM:AddHeader(optionsPanel, "Luminary_Banker_LowerVolume",  "Lower volume controls ")

  LAM:AddEditBox(optionsPanel, "HowMuchShouldIMute", SI.get(SI.HOWMUCHTOMUTEVOLUME),
      SI.get(SI.HOWMUCHTOMUTEVOLUME_INFO), false,
      function () return mBankerShutUpSV.VolumeControlToMute end, function(vol)mBankerShutUpSV.VolumeControlToMute = vol end )



  LAM:AddEditBox(optionsPanel, "HowMuchShouldIMuteAmbience", "Lower Ambience volume",
      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
      function () return mBankerShutUpSV.AmbienceMute end, function(vol)mBankerShutUpSV.AmbienceMute = vol end )


  LAM:AddEditBox(optionsPanel, "HowMuchShouldIMuteEffects", "Lower Effects volume",
      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
      function () return mBankerShutUpSV.EffectsMute end, function(vol)mBankerShutUpSV.EffectsMute = vol end )


  LAM:AddEditBox(optionsPanel, "HowMuchShouldIMuteFootsteps", "Lower Footsteps volume",
      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
      function () return mBankerShutUpSV.FootstepsMute end, function(vol)mBankerShutUpSV.FootstepsMute = vol end )


  LAM:AddEditBox(optionsPanel, "HowMuchShouldIMuteDialogue", "Lower Dialogue volume",
      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
      function () return mBankerShutUpSV.DialogueMute end, function(vol)mBankerShutUpSV.DialogueMute = vol end )


  LAM:AddEditBox(optionsPanel, "HowMuchShouldIMuteInterface", "Lower Interface volume",
      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
      function () return mBankerShutUpSV.InterfaceMute end, function(vol)mBankerShutUpSV.InterfaceMute = vol end )










  LAM:AddHeader(optionsPanel, "Luminary_Banker_ReturnVolume",  "Return volume controls ")


  LAM:AddEditBox(optionsPanel, "HowMuchShouldIReturnAmbience", "Return Ambience volume",
      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
      function () return mBankerShutUpSV.Ambience end, function(vol)mBankerShutUpSV.Ambience = vol end )


  LAM:AddEditBox(optionsPanel, "HowMuchShouldIReturnEffects", "Return Effects volume",
      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
      function () return mBankerShutUpSV.Effects end, function(vol)mBankerShutUpSV.Effects = vol end )


  LAM:AddEditBox(optionsPanel, "HowMuchShouldIReturnFootsteps", "Return Footsteps volume",
      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
      function () return mBankerShutUpSV.Footsteps end, function(vol)mBankerShutUpSV.Footsteps = vol end )


  LAM:AddEditBox(optionsPanel, "HowMuchShouldIReturnDialogue", "Return Dialogue volume",
      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
      function () return mBankerShutUpSV.Dialogue end, function(vol)mBankerShutUpSV.Dialogue = vol end )


  LAM:AddEditBox(optionsPanel, "HowMuchShouldIReturnInterface", "Return Interface volume",
      SI.get(SI.HOWMUCHTORETURNVOLUME_INFO), false,
      function () return mBankerShutUpSV.Interface end, function(vol)mBankerShutUpSV.Interface = vol end )





  LAM:AddHeader(optionsPanel, "BankerInfoAboutLuminary", BankerShutUp.var.color.colArtifact .. SI.get(SI.APPNAME)
   .. BankerShutUp.var.color.colWhite.. SI.get(SI.BETA)..BankerShutUp.var.color.colRed ..SI.get(SI.BUGSQUASHER)..
   BankerShutUp.var.color.colWhite.. SI.get(SI.REPORTTHATSHITYO))

  LAM:AddHeader(optionsPanel, "BankerILoveGoldDonations", BankerShutUp.var.color.colArtifact .. "\n\n\n\n".. SI.get(SI.ONLYGOOD)
  .. BankerShutUp.var.color.colLegendary .. SI.get(SI.DONATIONS) .. BankerShutUp.var.color.colWhite.. SI.get(SI.BADASS))

end

