local SI = BankerShutUp.SI
local npcTable = {}

function BankerShutUp.alertBankerLoaded()
    d(BankerShutUp.var.color.colArtifact .. "Luminary " .. BankerShutUp.var.color.colArcane .. "Banker Shutup loaded" .. " v" ..BankerShutUp.var.Version)
    EVENT_MANAGER:UnregisterForEvent(BankerShutUp.var.appName, EVENT_PLAYER_ACTIVATED)
end


function BankerShutUp.ShutUpQuick()

    if mBankerShutUpSV.OnlyTheBanker then
        SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_VO_VOLUME, mBankerShutUpSV.VolumeControlToMute)
    else
        SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AMBIENT_VOLUME, mBankerShutUpSV.AmbienceMute)
		SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_SFX_VOLUME, mBankerShutUpSV.EffectsMute)
		SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_FOOTSTEPS_VOLUME, mBankerShutUpSV.FootstepsMute)
		SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_VO_VOLUME, mBankerShutUpSV.DialogueMute)
		SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_UI_VOLUME, mBankerShutUpSV.InterfaceMute)
    end
end

local function removeNPCDuplicates(tbl)
    local npcname = {}
    local newTable = {}
    for _, record in pairs(tbl) do
        if npcname[record] == nil then
            npcname[record] = 1
            table.insert(newTable, record)
        end
    end
    return newTable
end


function BankerShutUp:ManualSoundShutup()
	SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AMBIENT_VOLUME, mBankerShutUpSV.AmbienceMute)
	SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_SFX_VOLUME, mBankerShutUpSV.EffectsMute)
	SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_FOOTSTEPS_VOLUME, mBankerShutUpSV.FootstepsMute)
	SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_VO_VOLUME, mBankerShutUpSV.DialogueMute)
	SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_UI_VOLUME, mBankerShutUpSV.InterfaceMute)
end

function BankerShutUp:manualShutUp()

    local e = {}
    npcTable = {}
    e.stringAction, e.name, e.interactBlocked, e.additionalInfo, e.contextualInfo = GetGameCameraInteractableActionInfo()
    table.insert(npcTable, e)
    for k,v in ipairs (npcTable) do --mBankerShutUpSV.ShutupTable[k] = v.name
            if mBankerShutUpSV.ShutupTable.name ~= v.name then
                table.insert(mBankerShutUpSV.ShutupTable, v.name)
                BankerShutUp.win.BankerShutUpUnMuter:SetHidden(false)
                BankerShutUp.win.BankerShutUpMuter:SetHidden(true)
                BankerShutUp:ManualSoundShutup()
        end
end


end

function BankerShutUp:manualShutUpUnShutup()
    local e = {}
    npcs = {}

    e.stringAction, e.name, e.interactBlocked, e.additionalInfo, e.contextualInfo = GetGameCameraInteractableActionInfo()
    for k, v in ipairs(mBankerShutUpSV.ShutupTable) do
        if v == e.name then
            BankerShutUp:imSorryDelay()
            --    if mBankerShutUpSV.ShutupTable.name == npcs.name then
            table.remove(mBankerShutUpSV.ShutupTable, k)
            BankerShutUp.win.BankerShutUpUnMuter:SetHidden(true)
            BankerShutUp.win.BankerShutUpMuter:SetHidden(false)
        end
    end
end


function BankerShutUp:shutup(idNumber, index)

    local e = {}
    local shouldMute = false
    mBankerShutUpSV.ShutupTable = removeNPCDuplicates(mBankerShutUpSV.ShutupTable)
    e.stringAction, e.name, e.interactBlocked, e.additionalInfo, e.contextualInfo = GetGameCameraInteractableActionInfo()


    for k, v in ipairs(mBankerShutUpSV.ShutupTable) do

        if v == e.name then
            BankerShutUp:ManualSoundShutup()
            BankerShutUp.win.BankerShutUpUnMuter:SetHidden(false)
            BankerShutUp.win.BankerShutUpMuter:SetHidden(true)
            return
        else

            BankerShutUp.win.BankerShutUpUnMuter:SetHidden(true)
            BankerShutUp.win.BankerShutUpMuter:SetHidden(false)
        end
    end
    if shouldMute then
        BankerShutUp:ManualSoundShutup()
    end



    if mBankerShutUpSV.SHUTUP_BANKER then
        local e = {}
        e.banker, e.someInt, e.anotherInt, e.someBool, e.anotherBool = GetChatterOption()
        if e.banker == "Bank" then --shut the fuck up ;)
            BankerShutUp.ShutUpQuick()
        end
    end
end

function BankerShutUp:shutupCraft(idNumber, index)

    if mBankerShutUpSV.SHUTUP_BLACKSMITH then
        if index == CRAFTING_TYPE_BLACKSMITHING then
            BankerShutUp.ShutUpQuick()
        end
    end

    if mBankerShutUpSV.SHUTUP_ALCH then
        if index == CRAFTING_TYPE_ALCHEMY then
            BankerShutUp.ShutUpQuick()
        end
    end

    if mBankerShutUpSV.SHUTUP_CLOTH then
        if index == CRAFTING_TYPE_CLOTHIER then
            BankerShutUp.ShutUpQuick()
        end
    end

    if mBankerShutUpSV.SHUTUP_WOODY then
        if index == CRAFTING_TYPE_WOODWORKING then
            BankerShutUp.ShutUpQuick()
        end
    end

    if mBankerShutUpSV.SHUTUP_COOK then
        if index == CRAFTING_TYPE_PROVISIONING then
            BankerShutUp.ShutUpQuick()
        end
    end

    if mBankerShutUpSV.SHUTUP_ENCHANTER then
        if index == CRAFTING_TYPE_ENCHANTING then
            BankerShutUp.ShutUpQuick()
        end
    end
end

function BankerShutUp:imSorryDelay()
	SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_AMBIENT_VOLUME, mBankerShutUpSV.Ambience)
	SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_SFX_VOLUME, mBankerShutUpSV.Effects)
	SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_FOOTSTEPS_VOLUME, mBankerShutUpSV.Footsteps)
	SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_VO_VOLUME, mBankerShutUpSV.Dialogue)
	SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_UI_VOLUME, mBankerShutUpSV.Interface)
end


function BankerShutUp:imSorry()
    zo_callLater(function() BankerShutUp.imSorryDelay() end, 500)
end




local function OnAddOnLoaded(eventCode, addOnName)
    if (BankerShutUp.var.appName ~= addOnName) then return end
    BankerShutUp.var.isAddonLoaded = true

    local Default = {
        ["SHUTUP_BLACKSMITH"] = false,
        ["SHUTUP_ALCH"] = false,
        ["SHUTUP_CLOTH"] = false,
        ["SHUTUP_WOODY"] = false,
        ["SHUTUP_COOK"] = false,
        ["SHUTUP_ENCHANTER"] = false,
        ["SHUTUP_BANKER"] = true,
        ["SHUTUP_COOK"] = false,
        ["VolumeControlToMute"] = 0,
        ["VolumeControlToRaise"] = 80,
        ["Ambience"] = 80,
        ["Effects"] = 80,
        ["Footsteps"] = 80,
        ["Dialogue"] = 80,
        ["Interface"] = 80,
        ["AmbienceMute"] = 0,
        ["EffectsMute"] = 0,
        ["FootstepsMute"] = 0,
        ["DialogueMute"] = 0,
        ["InterfaceMute"] = 0,
        ["OnlyTheBankerMute"] = false,
        ["ShutupTable"] = {}
    }

    -- Load saved variables
    mBankerShutUpSV = ZO_SavedVars:NewAccountWide("Luminary_BankerShutup_SV", 14, nil, Default, nil)



    EVENT_MANAGER:RegisterForEvent(BankerShutUp.var.appName, EVENT_PLAYER_ACTIVATED, BankerShutUp.alertBankerLoaded)


    EVENT_MANAGER:RegisterForEvent(BankerShutUp.var.appName, EVENT_CHATTER_BEGIN, BankerShutUp.shutup)
    EVENT_MANAGER:RegisterForEvent(BankerShutUp.var.appName, EVENT_CHATTER_END, BankerShutUp.imSorry)

    EVENT_MANAGER:RegisterForEvent(BankerShutUp.var.appName, EVENT_CRAFTING_STATION_INTERACT, BankerShutUp.shutupCraft)
    EVENT_MANAGER:RegisterForEvent(BankerShutUp.var.appName, EVENT_END_CRAFTING_STATION_INTERACT, BankerShutUp.imSorry)
    BankerShutUp.SetupOptionsMenu()
end

EVENT_MANAGER:RegisterForEvent(BankerShutUp.var.appName, EVENT_ADD_ON_LOADED, OnAddOnLoaded)