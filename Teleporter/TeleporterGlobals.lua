Teleporter = {}
Teleporter.win =   {
      wm = WINDOW_MANAGER,
      Main_Control = {},
}
Teleporter.var = {
  appName               = "Teleporter",
  controls               = {},  
  welcomeMsg            = "HELLO",
  loadMessageInterval   = 5,
  isAddonLoaded         = false,
  color                 = {
    colMagic     = "|c2dc50e", -- Magic Green (Uncommon)
    colTrash     = "|c777777", -- Trash Gray (Garbage)
    colYellow    = "|cFFFF00" ,--yellow
    colArcane    = "|c3689ef", -- Arcane Blue (Rare)
    colArtifact  = "|c912be1", -- Epic (Epic)
    colTeal      = "|c00FFFF", -- teal
    colWhite     = "|cFFFFFF", -- white
    colRed       = "|cFF0000", -- Red
    colLegendary = "|cd5b526", -- Legendary Gold (TheShit)
    colGreen     = "|c00FF00" --green
  },
    playerName = ""
}
--Teleporter.var.color.colRed
mTeleSavedVars = {}


function Teleporter:tooltipTextEnter(control, text, type)
    if type == true then
        InitializeTooltip(InformationTooltip, control, LEFT, 0, 0, 0)
        InformationTooltip:SetHidden(false) InformationTooltip:AddLine(text)
    else
        InformationTooltip:ClearLines()
        InformationTooltip:SetHidden(true)
    end
end