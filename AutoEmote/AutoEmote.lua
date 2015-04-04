local AutoEmote = {
    settings = {},
    saved = {}
}
-- I hate being in global space
local d = d  -- get Print out of global, good or bad idea? hmmm

local emoteList = {}


-- functions


function AutoEmote:Something()
    d("hahaha")
end
function AutoEmote:inTable(str, t)
    for _, v in pairs(t) do
        if str == v then
            return true
        end
    end
    return false
end

function AutoEmote:checkFirst(str, t)
    for _, v in pairs(t) do
       local  l = string.len(v)
        local sub = string.sub(str .. " ", 0, l)
        if v == sub then
            return true
        end
    end
    return false
end

function AutoEmote:checkLast(str, t)
    for _, v in pairs(t) do
        local l = string.len(v)
        local sub = string.sub(str, -l)
        if v == sub then
            return true
        end
    end
    return false
end

function AutoEmote:check(str, t)
    for _, v in pairs(t) do
        if string.find(" " .. str .. " ", v, 0, true) then
            return true
        end
    end
    return false
end


-- OnChatMessage Event
local function ParseChat(id, channel, fromName, text)
    assert(fromName ~= nil, "AutoEmote:ParseChat() fromName cannot be nil")
    assert(channel ~= nil, "AutoEmote:ParseChat() channel cannot be nil")
    assert(text ~= nil, "AutoEmote:ParseChat() text cannot be nil")
    local i = string.find(fromName, "^", 0, true) -- cut off weird name-suffix
    if i ~= nil then
        fromName = string.sub(fromName, 0, i - 1)
    end

    if AutoEmote.saved.active ~= true then return end -- is AutoEmote deactivated?
    if IsUnitInCombat("player") then return end -- no emotes when we fight!
    if IsPlayerMoving() then return end -- no emotes when we move around!
    if fromName ~= GetUnitName("player") then return end -- is chatmessage sent by someone else?

    if channel == CHAT_CHANNEL_PARTY then
        local gs = GetGroupSize()
        if gs < 2 then return end
        local groupcheck = false
        for x = 1, gs - 1 do
          local   tag = "group" .. x
            if IsUnitInGroupSupportRange(tag) then
                groupcheck = true
                x = 100
            end
        end
        if groupcheck == false then return end
    end

    local lower = string.lower(text) -- turn text into lowercase, for easier filtering
    local filter = AutoEmoteFilter[channel] -- select the filter for the current channel

    if filter == nil then return end -- filter is empty? abort!

    for _, v in pairs(filter) do
        local mode = v[1]
        local keywords = v[2]
        local emotes = v[3]

        local action = {
            true,
            AutoEmote:checkFirst(lower, keywords),
            AutoEmote:check(lower, keywords),
            AutoEmote:checkLast(lower, keywords)
        }
        if action[mode] then
            assert(emoteList[emotes[math.random(#emotes)]] ~= nil, "emoteList[emotes[math.random(#emotes)]] was nil")
            PlayEmoteByIndex(emoteList[emotes[math.random(#emotes)]])
            return
        end
    end
end


-- Slashcommand to enable/disable AutoEmote
function AutoEmote:AutoEmoteToggle(opt)
    if (AutoEmote.saved.active) then
        AutoEmote.saved.active = false
        d("AutoEmote disabled")
    else
        AutoEmote.saved.active = true
        d("AutoEmote activated")
    end
end


-- Handle Addon loading
local function AutoEmoteLoaded(eventCode, addOnName)
    if addOnName ~= "AutoEmote" then return end

    local defaults = {
        active = true
    }
    AutoEmote.saved = ZO_SavedVars:New("AutoEmoteSaved", 1, nil, defaults)

    SLASH_COMMANDS["/autoemote"] = AutoEmoteToggle

    local emotes = GetNumEmotes()
    assert(emotes ~= nil, "Emotes was nil")
    for i = 1, emotes do
        if (GetEmoteSlashNameByIndex(i) ~= nil) then
            assert(emoteList ~= nil, "EmoteList was nil")
            assert(emoteList ~= nil, "EmoteList was nil")
            emoteList[GetEmoteSlashNameByIndex(i)] = i
        end
    end

    -- Gather all emotes and put them in a neat table, so we can use slashcommands instead of IDs

    EVENT_MANAGER:RegisterForEvent("AutoEmoteMessageEvent", EVENT_CHAT_MESSAGE_CHANNEL, ParseChat)
end



EVENT_MANAGER:RegisterForEvent("AutoEmoteLoaded", EVENT_ADD_ON_LOADED, AutoEmoteLoaded)

SLASH_COMMANDS["/baz"] = function(extra)
    AutoEmote:Something()
end

