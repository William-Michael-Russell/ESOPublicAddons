local LL = LibStub('LibLuminary', 1)
if (not LL) then return end


local GuildManager = {
    name = "GuildManager",
    version = "165.0",
}

function GuildManager:Init()
    local init = ZO_Object:New()

     init = {
        anchorTargetControl = GuildManagerControl,
        title = "|cccccccAlchemist |cffff99" .. GuildManager.version,
        settings = {},
        width = 350,
        left = 970,
        top = 60,

        name = GuildManager.name,
        width = 500,
        height = 400,
        invitePlayer = {},
        hasBeenInvited = {},
    }

    return init
end

function GuildManager:DoSomething()
    d("Just Testing Stuff Out")
end




local function onLoadAddon(event, _AddonName)
    if (GuildManager.name ~= _AddonName) then return end

    GuildManager.cfg = GuildManager:Init()
    GuildManager.LL = LL:New(GuildManager.cfg)

    EVENT_MANAGER:RegisterForEvent(GuildManager.cfg.name, EVENT_CRAFTING_STATION_INTERACT, on_start_crafting)
end


EVENT_MANAGER:RegisterForEvent(GuildManager.cfg.name, EVENT_ADD_ON_LOADED, onLoadAddon)

SLASH_COMMANDS["/gm"] = function(extra)
    GuildManager:DoSomething()
end