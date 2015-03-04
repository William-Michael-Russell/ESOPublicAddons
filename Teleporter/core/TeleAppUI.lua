local LAM2 = LibStub("LibAddonMenu-2.0")
if ( not LAM2 ) then return end

local SI = Teleporter.SI ---- used for localization


local function SetupOptionsMenu(index)
  local panelData = {
    type = "panel",
    name = Teleporter.var.color.colArtifact.."Luminary"..Teleporter.var.color.colTeal.." Teleporter",
    displayName = Teleporter.var.color.colArtifact.."Luminary"..Teleporter.var.color.colTeal.." Teleporter",
    author = "awesomebilly - maintainer kerb9729",
    version = "3.8",
    slashCommand = "/teleporter",
    registerForRefresh = true,
    registerForDefaults = true,
  }

  local optionsData = {
    [1] = {
      type = "header",
      name = "Teleporter Options",
      width = "full",
      reference = Teleporter.var.appName.. "Header" .. index,
      },
    [2] = {
      type = "editbox",
      name = SI.get(SI.TELE_SET_PORTAL_FREQ),
      tooltip = SI.get(SI.TELE_SET_PORTAL_FREQ_INFO),
      getFunc = function () return mTeleSavedVars.AutoPortFreq end,
      setFunc = function(secs)mTeleSavedVars.AutoPortFreq = tonumber(secs) end,
      isMultiline = false,
      width = "full",
      default = function () return mTeleSavedVars.AutoPortFreq end,
      reference = "HowFrequentlyShouldIPortal",
      },
    [3] = {
      type = "checkbox",
      name = "Enable Verbose Logging?",
      tooltip = "This will Spam your client with developer logs",
      getFunc = function() return mTeleSavedVars.logV end,
      setFunc = function(val) mTeleSavedVars.logV = val end,
      width = "full",
      default = mTeleSavedVars.logV,
      reference = Teleporter.var.appName.. index.. "EnableVerboseLogging",
      },
    [4] = {
      type = "checkbox",
      name = "Enable Debug Logging?",
      tooltip = "This will inform you with debug logs",
      getFunc = function() return mTeleSavedVars.logD end,
      setFunc = function(val) mTeleSavedVars.logD = val end,
      width = "full",
      default = mTeleSavedVars.logD,
      reference = Teleporter.var.appName..index..  "EnableDebugLogging",
      },
    [5] = {
      type = "checkbox",
      name = "Enable Error Logging?",
      tooltip = "This will inform you with error logs",
      getFunc = function() return mTeleSavedVars.logE end,
      setFunc = function(val) mTeleSavedVars.logE = val end,
      width = "full",
      default = mTeleSavedVars.logE,
      reference = Teleporter.var.appName..index..  "EnableErrorLogging",
      },
    [6] = {
      type = "checkbox",
      name = "Do not show level 50s",
      tooltip = "This is for low level players to filter out 'vet' portal issues",
      getFunc = function() return mTeleSavedVars.FilterCloserToLevel end,
      setFunc = function(val) mTeleSavedVars.FilterCloserToLevel = val end,
      width = "full",
      default = mTeleSavedVars.FilterCloserToLevel,
      reference = Teleporter.var.appName..index..  "EnableCloserLoggingByLevel",
      },
    [7] = {
      type = "checkbox",
      name = "Open teleporter with map",
      tooltip = "When you open the map teleporter will automatically open as well, otherwise you'll get a button on the map.",
      getFunc = function() return    mTeleSavedVars.AutoOpenMap end,
      setFunc = function(val)    mTeleSavedVars.AutoOpenMap = val end,
      width = "full",
      default =    mTeleSavedVars.AutoOpenMap,
      reference = Teleporter.var.appName..index..  "OpenTheMapByDefault",
      },
  }
  LAM2:RegisterAddonPanel(Teleporter.var.appName..index.."ControlPanel", panelData)
  LAM2:RegisterOptionControls(Teleporter.var.appName..index.."ControlPanel", optionsData)

end

local function SetupUI()

  --------------------------------------------------------------------------------------------------------------
  --Main Controller. Please notice that Teleporter.win comes from our globals variables, as does Teleporter.win.wm
  -----------------------------------------------------------------------------------------------------------------
  Teleporter.win.Main_Control = Teleporter.win.wm:CreateTopLevelWindow("Teleporter_Location_MainController")
  Teleporter.win.Main_Control:SetMovable(true)
  Teleporter.win.Main_Control:SetMouseEnabled(true)
  Teleporter.win.Main_Control:SetDimensions(500,400)
  Teleporter.win.Main_Control:SetHidden(true)
  Teleporter.win.Main_Control:SetAlpha(1)
  Teleporter.win.Main_Control:SetResizeHandleSize(MOUSE_CURSOR_RESIZE_NS)

  Teleporter.win.appTitle =  Teleporter.win.wm:CreateControl("Teleporter" .. "_appTitle", Teleporter.win.Main_Control, CT_LABEL)
  Teleporter.win.appTitle:SetFont("ZoFontGame")
  Teleporter.win.appTitle:SetColor(255, 255, 255, 1)
  Teleporter.win.appTitle:SetText(Teleporter.var.color.colArtifact .. "LUMINARY" .. Teleporter.var.color.colWhite.. " Teleporter")
  Teleporter.win.appTitle:SetAnchor(0, Teleporter.win.Main_Control, 0, CENTER , -45)

  ----- This is where we create the list element for TeleUnicorn/ List
  TeleporterList = TeleUnicorn.ListView.new(Teleporter.win.Main_Control,  {
    width = 750,
    height = 500,
  })

  
  ------------------------- SEARCHER

   Teleporter.win.Searcher = CreateControlFromVirtual("Teleporter_SEARCH_EDITBOX",  Teleporter.win.Main_Control, "ZO_DefaultEditForBackdrop")
   Teleporter.win.Searcher:SetParent( Teleporter.win.Main_Control)
  --    local BOTTOMz =  Teleporter.win
   Teleporter.win.Searcher:SetSimpleAnchorParent(15,25)
  --   Teleporter.win.Searcher:SetAnchor(BOTTOMLEFT,  Teleporter.win, BOTTOMLEFT, 0, -15)
   Teleporter.win.Searcher:SetDimensions(100,25)
   Teleporter.win.Searcher:SetResizeToFitDescendents(false)
  --  Teleporter.win.Searcher:SetMouseEnabled(true)
  --   Teleporter.win.Searcher:SetText("Search..")
  --   Teleporter.win.Searcher:SetHandler("OnClicked", function() Teleporter.win.ALERTMAXLIST:SetText("")  end)
  
  

  ZO_PreHookHandler( Teleporter.win.Searcher, "OnTextChanged", function(self) Teleporter.CheckGuildMemeberStatus(3, Teleporter.win.Searcher:GetText(), true) end)

  Teleporter.win.SearchBG = WINDOW_MANAGER:CreateControlFromVirtual(" Teleporter.win.SearchBG",  Teleporter.win.Searcher, "ZO_DefaultBackdrop")
  Teleporter.win.SearchBG:ClearAnchors()
  Teleporter.win.SearchBG:SetAnchorFill( Teleporter.win.Searcher)
  Teleporter.win.SearchBG:SetDimensions( Teleporter.win.Searcher:GetWidth(),  Teleporter.win.Searcher:GetHeight())
  Teleporter.win.SearchBG.controlType = CT_CONTROL
  Teleporter.win.SearchBG.system = SETTING_TYPE_UI
  Teleporter.win.SearchBG:SetHidden(false)
  Teleporter.win.SearchBG:SetMouseEnabled(false)
  Teleporter.win.SearchBG:SetMovable(false)

  Teleporter.win.SearchBG:SetClampedToScreen(true)


  Teleporter.win.SearchTexture = WINDOW_MANAGER:CreateControl("Teleporter.win.Main_Contmrol.SearchTexture",  Teleporter.win.SearchBG, CT_TEXTURE)
  --  Teleporter.win.RefreshTexture:SetAnchorFill( Teleporter.win.Searcher)
  Teleporter.win.SearchTexture:SetDimensions(50,50)
  Teleporter.win.SearchTexture:SetAnchor(RIGHT,  Teleporter.win.SearchBG, RIGHT, RIGHT + 30, 0)
  Teleporter.win.SearchTexture:SetTexture("/esoui/art/miscellaneous/search_icon.dds")
  Teleporter.win.SearchTexture:SetTextureCoords(0, 1, 0, 1)




  Teleporter.win.Searcher.SearchTextureLBL = WINDOW_MANAGER:CreateControl("TELEPORTERALERTS", Teleporter.win.Searcher, CT_BUTTON)
  Teleporter.win.Searcher.SearchTextureLBL:SetParent(Teleporter.win.Searcher)
  Teleporter.win.Searcher.SearchTextureLBL:SetSimpleAnchorParent(15, 0)
  Teleporter.win.Searcher.SearchTextureLBL:SetDimensions(100, 10)
  Teleporter.win.Searcher.SearchTextureLBL:SetFont("ZoFontGame")
  Teleporter.win.Searcher.SearchTextureLBL:SetAlpha(1)
    Teleporter.win.Searcher.SearchTextureLBL:SetHandler("OnMouseEnter", function(self)
      Teleporter.win.Searcher.SearchTextureLBL:SetAlpha(0.5)
      Teleporter:tooltipTextEnter( Teleporter.win.Searcher.SearchTextureLBL,
          "Search By Player.", true)

  end)

  Teleporter.win.Searcher.SearchTextureLBL:SetHandler("OnMouseExit", function(self)
      Teleporter.win.Searcher.SearchTextureLBL:SetAlpha(1)
      Teleporter:tooltipTextEnter(Teleporter.win.Searcher.SearchTextureLBL)
  end)






  ------------------------- SEARCHER

  Teleporter.win.Searcher_Player = CreateControlFromVirtual("Teleporter_Searcher_Player_EDITBOX1",  Teleporter.win.Main_Control, "ZO_DefaultEditForBackdrop")
  Teleporter.win.Searcher_Player:SetParent( Teleporter.win.Main_Control)
  Teleporter.win.Searcher_Player:SetSimpleAnchorParent(145,25)
  Teleporter.win.Searcher_Player:SetDimensions(100,25)
  Teleporter.win.Searcher_Player:SetResizeToFitDescendents(false)


  ZO_PreHookHandler( Teleporter.win.Searcher_Player, "OnTextChanged", function(self) Teleporter.CheckGuildMemeberStatus(3, Teleporter.win.Searcher_Player:GetText(), false) end)

  Teleporter.win.SearchBG_Player = WINDOW_MANAGER:CreateControlFromVirtual(" Teleporter.win.SearchBG_Player1",  Teleporter.win.Searcher_Player, "ZO_DefaultBackdrop")
  Teleporter.win.SearchBG_Player:ClearAnchors()
  Teleporter.win.SearchBG_Player:SetAnchorFill( Teleporter.win.Searcher_Player)
  Teleporter.win.SearchBG_Player:SetDimensions( Teleporter.win.Searcher_Player:GetWidth(),  Teleporter.win.Searcher_Player:GetHeight())
  Teleporter.win.SearchBG_Player.controlType = CT_CONTROL
  Teleporter.win.SearchBG_Player.system = SETTING_TYPE_UI
  Teleporter.win.SearchBG_Player:SetHidden(false)
  Teleporter.win.SearchBG_Player:SetMouseEnabled(false)
  Teleporter.win.SearchBG_Player:SetMovable(false)

  Teleporter.win.SearchBG_Player:SetClampedToScreen(true)


  Teleporter.win.Search_Player_Texture = WINDOW_MANAGER:CreateControl("Teleporter.win.Main_Contmrol.SearchTexture1",  Teleporter.win.Searcher_Player, CT_TEXTURE)
  --  Teleporter.win.RefreshTexture:SetAnchorFill( Teleporter.win.Searcher)
  Teleporter.win.Search_Player_Texture:SetDimensions(50,50)
  Teleporter.win.Search_Player_Texture:SetAnchor(RIGHT,  Teleporter.win.SearchBG_Player, RIGHT, RIGHT + 30, 0)
  Teleporter.win.Search_Player_Texture:SetTexture("/esoui/art/miscellaneous/search_icon.dds")
  Teleporter.win.Search_Player_Texture:SetTextureCoords(0, 1, 0, 1)




  Teleporter.win.Searcher_Player.Search_Player_TextureLBL = WINDOW_MANAGER:CreateControl("TELEPORTERALERTS1", Teleporter.win.Searcher, CT_BUTTON)
  Teleporter.win.Searcher_Player.Search_Player_TextureLBL:SetParent(Teleporter.win.Searcher)
  Teleporter.win.Searcher_Player.Search_Player_TextureLBL:SetSimpleAnchorParent(145, 0)
  Teleporter.win.Searcher_Player.Search_Player_TextureLBL:SetDimensions(100, 10)
  Teleporter.win.Searcher_Player.Search_Player_TextureLBL:SetFont("ZoFontGame")
  Teleporter.win.Searcher_Player.Search_Player_TextureLBL:SetAlpha(1)
  Teleporter.win.Searcher_Player.Search_Player_TextureLBL:SetHandler("OnMouseEnter", function(self)
      Teleporter.win.Searcher_Player.Search_Player_TextureLBL:SetAlpha(0.5)
      Teleporter:tooltipTextEnter( Teleporter.win.Searcher_Player.Search_Player_TextureLBL,
          "Search By Zone.", true)

  end)

  Teleporter.win.Searcher_Player.Search_Player_TextureLBL:SetHandler("OnMouseExit", function(self)
      Teleporter.win.Searcher_Player.Search_Player_TextureLBL:SetAlpha(1)
      Teleporter:tooltipTextEnter(Teleporter.win.Searcher_Player.Search_Player_TextureLBL)
  end)










  -------------------------------------------------------------------
  --CLOSE

  Teleporter.win.closeTexture = WINDOW_MANAGER:CreateControl(nil, Teleporter.win.Main_Control, CT_TEXTURE)
  Teleporter.win.closeTexture:SetDimensions(60, 60)
  Teleporter.win.closeTexture:SetAnchor(TOPRIGHT, Teleporter.win.Main_Control, TOPRIGHT, TOPRIGHT + 35, -75)
  Teleporter.win.closeTexture:SetTexture("/esoui/art/crafting/crafting_smithing_notrait.dds")
  Teleporter.win.closeTexture:SetTextureCoords(0, 1, 0, 1)
  Teleporter.win.closeTexture:SetAlpha(0.5)


  Teleporter.win.closeTexturebutton = WINDOW_MANAGER:CreateControl(nil, Teleporter.win.closeTexture, CT_BUTTON)
  Teleporter.win.closeTexturebutton:SetAnchorFill(Teleporter.win.closeTexture)
  Teleporter.win.closeTexturebutton:SetDimensions(25, 25)
  Teleporter.win.closeTexturebutton:SetHandler("OnClicked", function()
      Teleporter.win.MapOpen:SetHidden(false)
      Teleporter.HideUIz()  end)
  Teleporter.win.closeTexturebutton:SetHandler("OnMouseEnter", function(self)
      Teleporter.win.closeTexture:SetAlpha(1)

      Teleporter:tooltipTextEnter(Teleporter.win.closeTexture,
          "Close.", true)

  end)


  Teleporter.win.closeTexturebutton:SetHandler("OnMouseExit", function(self)
      Teleporter.win.closeTexture:SetAlpha(0.5)
      Teleporter:tooltipTextEnter(Teleporter.win.closeTexture)
  end)


  Teleporter.win.MapOpen = CreateControlFromVirtual("TeleporterReopenButon", ZO_WorldMap, "ZO_DefaultButton")
  Teleporter.win.MapOpen:SetAnchor(TOPLEFT)
  Teleporter.win.MapOpen:SetWidth(200)
  Teleporter.win.MapOpen:SetHidden(true)
  Teleporter.win.MapOpen:SetText("Teleporter")
  Teleporter.win.MapOpen:SetHandler("OnClicked",function()
  Teleporter.win.MapOpen:SetHidden(true)
  Teleporter.OpenTeleporter() end)




  Teleporter.win.Main_Control.RefreshTexture = WINDOW_MANAGER:CreateControl(nil, Teleporter.win.Main_Control, CT_TEXTURE)
  Teleporter.win.Main_Control.RefreshTexture:SetDimensions(60, 60)
  Teleporter.win.Main_Control.RefreshTexture:SetAnchor(TOPRIGHT, Teleporter.win.Main_Control, TOPRIGHT, 0, -5)
  -- lthline.frame:SetAnchor(0, lthline, 0, LEFT, 20)
  Teleporter.win.Main_Control.RefreshTexture:SetTexture("/Teleporter/media/radialicon_trade_disabled.dds")
  Teleporter.win.Main_Control.RefreshTexture:SetTextureCoords(0, 1, 0, 1)
  Teleporter.win.Main_Control.RefreshTexture:SetAlpha(1)
 -- Teleporter.win.Main_Control.RefreshTexture:SetHandler("OnClicked", refreshTotalSales)

  Teleporter.win.Main_Control.RefreshBtn = WINDOW_MANAGER:CreateControl(nil, Teleporter.win.Main_Control.RefreshTexture, CT_BUTTON)
  Teleporter.win.Main_Control.RefreshBtn:SetAnchorFill(Teleporter.win.Main_Control.RefreshTexture)
  Teleporter.win.Main_Control.RefreshBtn:SetDimensions(25, 25)
  --Teleporter.win.Main_Control.RefreshBtn:SetWidth(100)
  --Teleporter.win.Main_Control.RefreshBtn:SetText(SI.get(SI.TELEREFRESH))

  Teleporter.win.Main_Control.RefreshBtn:SetHandler("OnClicked", function() RefreshGuildList()end)
  Teleporter.win.Main_Control.RefreshBtn:SetHandler("OnMouseEnter", function(self)
      Teleporter:tooltipTextEnter(Teleporter.win.Main_Control.RefreshBtn,
          "Refresh all zones!", true)
      Teleporter.win.Main_Control.RefreshTexture:SetTexture("/Teleporter/media/radialicon_trade_over.dds")end)

  Teleporter.win.Main_Control.RefreshBtn:SetHandler("OnMouseExit", function(self)
      Teleporter:tooltipTextEnter(Teleporter.win.Main_Control.RefreshBtn)
      Teleporter.win.Main_Control.RefreshTexture:SetTexture("/Teleporter/media/radialicon_trade_disabled.dds")end)


  Teleporter.win.Main_Control.FPSCounter = WINDOW_MANAGER:CreateControl("TELEPORT_FPS_COUNTER", Teleporter.win.Main_Control.RefreshTexture, CT_LABEL)
  Teleporter.win.Main_Control.FPSCounter:SetDimensions(300, 100)
  Teleporter.win.Main_Control.FPSCounter:SetFont("ZoFontGame")
  Teleporter.win.Main_Control.FPSCounter:SetColor(255, 255, 255, 1)
  Teleporter.win.Main_Control.FPSCounter:SetText("")
  Teleporter.win.Main_Control.FPSCounter:SetAnchor(TOPRIGHT, Teleporter.win.Main_Control.RefreshTexture, TOPRIGHT, TOPRIGHT +150, -20)


--
--
--  Teleporter.win.Main_Control.portalToAllTexture = WINDOW_MANAGER:CreateControl(nil, Teleporter.win.Main_Control, CT_TEXTURE)
--  Teleporter.win.Main_Control.portalToAllTexture:SetDimensions(60, 60)
--  Teleporter.win.Main_Control.portalToAllTexture:SetAnchor(TOPRIGHT, Teleporter.win.Main_Control, TOPRIGHT, -40, -5)
--  -- lthline.frame:SetAnchor(0, lthline, 0, LEFT, 20)
--  Teleporter.win.Main_Control.portalToAllTexture:SetTexture("/Teleporter/media/revivemeter_frame.dds")
--  Teleporter.win.Main_Control.portalToAllTexture:SetTextureCoords(0, 1, 0, 1)
--  Teleporter.win.Main_Control.portalToAllTexture:SetAlpha(1)
--  -- Teleporter.win.Main_Control.RefreshTexture:SetHandler("OnClicked", refreshTotalSales)
--
--
--
--
--  ------------- ALL
--  Teleporter.win.Main_Control.portalToAll = WINDOW_MANAGER:CreateControl(nil, Teleporter.win.Main_Control.portalToAllTexture, CT_BUTTON)
--  Teleporter.win.Main_Control.portalToAll:SetAnchorFill(Teleporter.win.Main_Control.portalToAllTexture)
--  Teleporter.win.Main_Control.portalToAll:SetDimensions(25, 25)
--  --Teleporter.win.Main_Control.RefreshBtn:SetWidth(100)
--  --Teleporter.win.Main_Control.RefreshBtn:SetText(SI.get(SI.TELEREFRESH))
--  Teleporter.win.Main_Control.portalToAll:SetHandler("OnClicked", function() Teleporter.AutoTeleportWithoutCir() end)
--  Teleporter.win.Main_Control.portalToAll:SetHandler("OnMouseEnter", function(self)
--      Teleporter.win.Main_Control.portalToAllTexture:SetTexture("/Teleporter/media/radialicon_addfriend_over.dds")end)
--
--  Teleporter.win.Main_Control.portalToAll:SetHandler("OnMouseExit", function(self)
--      Teleporter.win.Main_Control.portalToAllTexture:SetTexture("/Teleporter/media/radialicon_addfriend_disabled.dds")end)
--
--
--
--
--




  Teleporter.win.Main_Control.portalToAllTexture = WINDOW_MANAGER:CreateControl(nil, Teleporter.win.Main_Control, CT_TEXTURE)
  Teleporter.win.Main_Control.portalToAllTexture:SetDimensions(55, 55)
  Teleporter.win.Main_Control.portalToAllTexture:SetAnchor(TOPRIGHT, Teleporter.win.Main_Control, TOPRIGHT, -40, -5)
  -- lthline.frame:SetAnchor(0, lthline, 0, LEFT, 20)
  Teleporter.win.Main_Control.portalToAllTexture:SetTexture("/Teleporter/media/group_pin.dds")
  Teleporter.win.Main_Control.portalToAllTexture:SetTextureCoords(0, 1, 0, 1)
  Teleporter.win.Main_Control.portalToAllTexture:SetAlpha(1)
  -- Teleporter.win.Main_Control.RefreshTexture:SetHandler("OnClicked", refreshTotalSales)




  Teleporter.win.Main_Control.portalToAll = WINDOW_MANAGER:CreateControl(nil, Teleporter.win.Main_Control.portalToAllTexture, CT_BUTTON)
  Teleporter.win.Main_Control.portalToAll:SetAnchorFill(Teleporter.win.Main_Control.portalToAllTexture)
  Teleporter.win.Main_Control.portalToAll:SetDimensions(25, 25)
  --Teleporter.win.Main_Control.RefreshBtn:SetWidth(100)
  --Teleporter.win.Main_Control.RefreshBtn:SetText(SI.get(SI.TELEREFRESH))
  Teleporter.win.Main_Control.portalToAll:SetHandler("OnClicked", function() Teleporter.AutoTeleportWithoutCir() end)
  Teleporter.win.Main_Control.portalToAll:SetHandler("OnMouseEnter", function(self)
      Teleporter:tooltipTextEnter(Teleporter.win.Main_Control.portalToAll,
          "Click and wait ... ;)", true)
      Teleporter.win.Main_Control.portalToAllTexture:SetAlpha(0.4)end)

  Teleporter.win.Main_Control.portalToAll:SetHandler("OnMouseExit", function(self)
      Teleporter:tooltipTextEnter(Teleporter.win.Main_Control.portalToAll)
      Teleporter.win.Main_Control.portalToAllTexture:SetAlpha(1)end)



  ---------------------------------------------------------------------------------------------------------------
  -- Only Your Zone
  -------
  -- Texture
  Teleporter.win.Main_Control.OnlyYourzoneTexture = WINDOW_MANAGER:CreateControl(nil, Teleporter.win.Main_Control, CT_TEXTURE)
  Teleporter.win.Main_Control.OnlyYourzoneTexture:SetDimensions(50, 50)
  Teleporter.win.Main_Control.OnlyYourzoneTexture:SetAnchor(TOPRIGHT, Teleporter.win.Main_Control, TOPRIGHT, -80, -3)
  -- lthline.frame:SetAnchor(0, lthline, 0, LEFT, 20)
  Teleporter.win.Main_Control.OnlyYourzoneTexture:SetTexture("/Teleporter/media/radialicon_removefriend_disabled.dds")
  Teleporter.win.Main_Control.OnlyYourzoneTexture:SetTextureCoords(0, 1, 0, 1)
  Teleporter.win.Main_Control.OnlyYourzoneTexture:SetAlpha(1)
  -- Teleporter.win.Main_Control.RefreshTexture:SetHandler("OnClicked", refreshTotalSales)

  -----
--  BUTTON
  Teleporter.win.Main_Control.OnlyYourzone = WINDOW_MANAGER:CreateControl(nil, Teleporter.win.Main_Control.OnlyYourzoneTexture, CT_BUTTON)
  Teleporter.win.Main_Control.OnlyYourzone:SetAnchorFill(Teleporter.win.Main_Control.OnlyYourzoneTexture)
  Teleporter.win.Main_Control.OnlyYourzone:SetDimensions(25, 25)
  --Teleporter.win.Main_Control.RefreshBtn:SetWidth(100)
  --Teleporter.win.Main_Control.RefreshBtn:SetText(SI.get(SI.TELEREFRESH))
  Teleporter.win.Main_Control.OnlyYourzone:SetHandler("OnClicked", function() Teleporter.FastPortalToPlayer() end)
  Teleporter.win.Main_Control.OnlyYourzone:SetHandler("OnMouseEnter", function(self)

      Teleporter:tooltipTextEnter(Teleporter.win.Main_Control.OnlyYourzone,
          "Only your zone.", true)
      Teleporter.win.Main_Control.OnlyYourzoneTexture:SetTexture("/Teleporter/media/radialicon_removefriend_over.dds")end)

  Teleporter.win.Main_Control.OnlyYourzone:SetHandler("OnMouseExit", function(self)
      Teleporter:tooltipTextEnter(Teleporter.win.Main_Control.OnlyYourzone)
      Teleporter.win.Main_Control.OnlyYourzoneTexture:SetTexture("/Teleporter/media/radialicon_removefriend_disabled.dds")end)








  local ILoveGold = CreateControlFromVirtual(Teleporter.var.appName.. "Teleporter_SendMeGold" .. "WarningIcon", Teleporter.win.Main_Control, "ZO_Options_WarningIcon")
  ILoveGold:SetAnchor(0, Teleporter.win.Main_Control, 0, LEFT -20, -25)
  ILoveGold.tooltipText = "I hope you enjoy this addon!\n Since I develop addons I'm super poor ;) I love in game gold \n @awesomebilly (North-America server)"



--  Teleporter.win.Main_Control.CloseBtn = CreateControlFromVirtual("Teleporter_CloseBtn", Teleporter.win.Main_Control, "ZO_DefaultButton")
--  Teleporter.win.Main_Control.CloseBtn:SetAnchor(BOTTOMRIGHT, Teleporter.win.Main_Control, BOTTOMRIGHT, 0, 30)
--  Teleporter.win.Main_Control.CloseBtn:SetWidth(100)
--  Teleporter.win.Main_Control.CloseBtn:SetText(SI.get(SI.TELECLOSE))
--  Teleporter.win.Main_Control.CloseBtn:SetHandler("OnClicked", function() Teleporter.HideUIz()end)
end







function TeleporterSetupUI(addOnName)
  if "Teleporter" ~= addOnName then return end
  SetupOptionsMenu(addOnName)
  SetupUI()
end
