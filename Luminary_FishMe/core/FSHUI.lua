local LAM = LibStub( 'LibAddonMenu-1.0' )
if ( not LAM ) then return end
local SI = mFSHConfig.SI
local function SetupOptionsMenu(index)


  local optionsPanelz = LAM:CreateControlPanel("Luminary_FSH_Options_Settings1", mFSHConfig.col.colArtifact .. "Luminary" .. mFSHConfig.col.colMagic .. "\nFishMe" .. "v." .. mFSHConfig.Version)
  LAM:AddHeader(optionsPanelz, "Luminary_FSH_Options_Use_Default1",  mFSHConfig.col.colArtifact .."Luminary " .. mFSHConfig.col.colWhite .. SI.get(SI.FISHOPTIONS))



  LAM:AddCheckbox(optionsPanelz, "FishBaitAlerts", SI.get(SI.RECEIVEBAITALERTS), SI.get(SI.BAITMSG),
    function() return mSavedFHVars.Enable_Fish_Bait end,
    function(val) mSavedFHVars.Enable_Fish_Bait = val
    end)
    
      LAM:AddCheckbox(optionsPanelz, "ReelInAlerts", SI.get(SI.RECEIVEREELALERTS), SI.get(SI.REELMSG),
    function() return mSavedFHVars.Enable_Reel_Alerts end,
    function(val) mSavedFHVars.Enable_Reel_Alerts = val
    end)
    
    
    LAM:AddCheckbox(optionsPanelz, "HelpFshDev", SI.get(SI.BUGFOUND), SI.get(SI.MISSINGSTUFF),
    function() return mSavedFHVars.Enable_Help_Dev end,
    function(val) mSavedFHVars.Enable_Help_Dev = val
    end)
    

  LAM:AddHeader(optionsPanelz, "InfoAboutLuminary1", mFSHConfig.col.colArtifact .. SI.get(SI.APPNAME)
   .. mFSHConfig.col.colWhite.. SI.get(SI.BETA)..mFSHConfig.col.colRed ..SI.get(SI.BUGSQUASHER).. 
   mFSHConfig.col.colWhite.. SI.get(SI.REPORTTHATSHITYO))
   
  LAM:AddHeader(optionsPanelz, "GoldDonationsAreAwesome", mFSHConfig.col.colArtifact .. "\n\n\n\n".. SI.get(SI.ONLYGOOD)
  .. mFSHConfig.col.colLegendary .. SI.get(SI.DONATIONS) .. mFSHConfig.col.colWhite.. SI.get(SI.BADASS))


end

function FSHsetup_display(name, index)

  if FishMe_UI == nil then
    FishMe_UI = WINDOW_MANAGER:CreateTopLevelWindow("FishMez" .. index)
    FishMe_UI:SetMovable(true)
    FishMe_UI:SetDimensions(425,25)
    FishMe_UI:SetHidden(false)
    FishMe_UI:SetAlpha(1)
    FishMe_UI:SetDrawLayer(1)
    FishMe_UI:SetAnchor(0,GuiRoot,CENTERRIGHT, 1100,500)

    FishMe_UI:SetMouseEnabled(true)

    FishAlert = WINDOW_MANAGER:CreateControl("FishLabel", FishMe_UI,CT_LABEL)
    FishAlert:SetDimensions(400, 25)
    FishAlert:SetHidden(false)
    FishAlert:SetFont("ZoFontHeader4")
    FishAlert:SetColor(255,255,255,255)
    FishAlert:SetAlpha(1)
    FishAlert:SetAnchorFill(FishMe_UI)
    FishAlert:SetText("")

    SetupOptionsMenu(1)
  end


end