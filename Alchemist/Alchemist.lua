--local LL = LibStub('Alch-2.0', 1)
--if (not LL) then return end
--Alchemist = {}

--local Alchemist.control.twl = LL:init(config)
local ROW_HEIGHT = 30
Alchemist = {
    version = "1.6.5.0",
}


local Alchy = ZO_Object:New()

function Alchy:New()

    local obj = ZO_Object.New(self)
    obj.addonName = {}
    obj.name = "Alchemist"
    obj.version = '1.6.5.1'
    obj.Batteries = {
        table_keys_to_list = table_keys_to_list,
        num_items_in_table = num_items_in_table,
        combinations = combinations,
        element_is_in_table = element_is_in_table,
    }
    obj.tbl = {}
    obj.mainControl = Alchy:CreateScrollList()
    obj.scrollList = obj.mainControl.list
    obj.self = self


    obj.anchorTargetControl = ZO_AlchemyTopLevelInvenotry
    obj.width = 450
    obj.height = 400
    obj.sv = {}
    return obj
end



function Alchy:blah()
    Alchemist.print_combinations(self)
end


function Alchy:CreateScrollList()
    local win = {}

    win.tlw = WINDOW_MANAGER:CreateTopLevelWindow("awesomezz")
    win.tlw:SetDimensions(275, 200)
    win.tlw:SetHidden(false)
    win.tlw:SetMouseEnabled(true)
    win.tlw:SetMovable(true)
    -- Exception for positioning if esoStats is loaded.

    win.tlw:SetAnchor(CENTER, GuiRoot, CENTER, 15, 0)

    win.tlw:SetHandler("OnShow", function()
        --                local scrollBar = scrollList.scrollbar
        --                local minValue, maxValue = scrollBar:GetMinMax()
        --                local centerValue = self.playerRank * ROW_HEIGHT - (scrollList:GetHeight() / 2)
        --                scrollBar:SetValue(centerValue)
    end)

    win.bg = WINDOW_MANAGER:CreateControl("Bg7z", win.tlw, CT_BACKDROP)
    win.bg:SetAnchorFill(win.tlw)

    win.bg:SetEdgeTexture("EsoUI/Art/ChatWindow/chat_BG_edge.dds", 256, 256, 32)
    win.bg:SetCenterTexture("EsoUI/Art/ChatWindow/chat_BG_center.dds")
    win.bg:SetInsets(32, 32, -32, -32)
    --    bg:SetDimensionConstraints(500, 500)

    win.list = WINDOW_MANAGER:CreateControlFromVirtual("awesomezzList", win.tlw, "ZO_ScrollList")
    self.scrollList = win.list
    win.list:SetAnchor(TOPLEFT, win.tlw, TOPLEFT, 10, 30)
    win.list:SetAnchor(BOTTOMRIGHT, win.tlw, BOTTOMRIGHT, -10, -10)
    win.list:SetAlpha(1)

    self.c_scrollList = win.list

    return win
end

function Alchy:print_combinations()

    local inventory = Inventory:new()
    assert(inventory ~= nil, "Because... this hates me...")
    self.tbl = {}
    local entryList = ZO_ScrollList_GetDataList(self.scrollList)
    local discovery = 1
    self.tbl[discovery] = {}
    --
    --
    inventory:populate_from_control(ALCHEMY["inventory"])
    --
    local num_reagent_slots = self.get_num_reagent_slots()
    local combinations = get_optimal_combinations(inventory, num_reagent_slots)

    d("Dont be nil")
    d(#combinations)
    local t = {}
    t.combineTheFollowing = SI.get(SI.COMBINE_THE_FOLLOWING)
    t.noDiscoveries = SI.get(SI.NO_DISCOVERIES_AVAILABLE)
    t.reagents = {}
    t.discovery = {}


    if #combinations == 0 then

    else


        for _, combination in pairs(combinations) do
            --This prints here
            --            mw:add_message(SI.get(SI.COMBINE_THE_FOLLOWING))
            table.sort(combination.reagents, function(a, b) return a.name < b.name end)
            for _, reagent in pairs(combination.reagents) do
                --should have added reagent here
                --                mw:add_message("- |c00ff00" .. reagent.name)
                table.insert(t.reagents, reagent)
            end
            --Another line was added here..
            --            mw:add_message(SI.get(SI.TO_GET_THE_FOLLOWING_DISCOVERIES))
            table.sort(combination.discoveries, function(a, b) return a.reagent.name < b.reagent.name end)
            for _, discovery in pairs(combination.discoveries) do
                -- another msg
                -- mw:add_message("- |c9999ff" .. discovery.reagent.name .. ": " .. discovery.trait)
                table.insert(t.discovery, discovery)
            end
        end
    end

    for counter, combination in pairs(combinations) do

        local entry = ZO_ScrollList_CreateDataEntry(1, t)
        table.insert(entryList, entry)
    end



    local shithead = 0
    local function listRow_Setup(listContoller, data, list)
        shithead = shithead + 1

        listContoller:SetHeight(ROW_HEIGHT)
        listContoller:SetFont("ZoFontWinH4")
        listContoller:SetHorizontalAlignment(TEXT_ALIGN_LEFT)
        listContoller:SetVerticalAlignment(TEXT_ALIGN_CENTER)
        listContoller:SetWrapMode(TEXT_WRAP_MODE_ELLIPSIS)
        if (#combinations - 1 ~= shithead) then
            listContoller:SetText(data.dataEntry.data.discovery[shithead].reagent.name)
        end
    end

    ZO_ScrollList_AddDataType(self.scrollList, 1, "ZO_SelectableLabel", ROW_HEIGHT, listRow_Setup)



    ZO_ScrollList_Commit(self.scrollList)
    --    -----------------------------------------------------------
    --
    --
    --
    --
    --
    --    --    for i = 1, 15 do
    --    --        table.insert(self.tbl[discovery], stuff)
    --    --    end
    --
    --    --    for i = 1, #self.tbl[discovery] do
    --    --        local entry = ZO_ScrollList_CreateDataEntry(1, self.tbl[discovery][i])
    --    --        table.insert(entryList, entry)
    --    --    end
end


function on_start_crafting(event_type, crafting_type)
    if crafting_type == CRAFTING_TYPE_ALCHEMY then
        Alchemist.scrollList:SetHidden(false)
        --    zo_callLater(function() Alchemist.print_combinations() end, 1000)
    end
end

function on_end_crafting(event_type, crafting_type)
    -- Alchemist.control.twl:SetHidden(true)
end

function on_craft_started(event_type, crafting_type)
    if crafting_type == CRAFTING_TYPE_ALCHEMY then
    end
end

function on_craft_completed(event_type, crafting_type)
    if crafting_type == CRAFTING_TYPE_ALCHEMY then
        --   Alchemist.control.twl:ClearText()
        --  zo_callLater(function() Alchemist.print_combinations() end, 500)
    end
end






local function on_addon_load(eventCode, addOnName)
    if addOnName == "Alchemist" then

        Alchemist = Alchy:New()

        --        Alchemist:Initialize()

        EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_CRAFTING_STATION_INTERACT, on_start_crafting)
        EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_END_CRAFTING_STATION_INTERACT, on_end_crafting)

        -- EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_TRAIT_LEARNED, on_craft_completed)
        EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_CRAFT_STARTED, on_craft_started)
        EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_CRAFT_COMPLETED, on_craft_completed)
        -- setupAdditionalUI()
    end
end


--
--function Alchy:setupAdditionalUI()
--    local btn = {}
--    btn.close = CreateControlFromVirtual("AlchClose", Alchemist.control.twl, "ZO_DefaultButton")
--    btn.close:SetAnchor(BOTTOMRIGHT, anchorTargetControl, TOPRIGHT, 0, 40)
--    btn.close:SetWidth(150)
--    btn.close:SetText("Close")
--    btn.close:SetHandler("OnClicked", function(self) btn.closeAlch()
--    end)
--
--
--    btn.open = CreateControlFromVirtual("AlchOpen", ZO_AlchemyTopLevelInventory, "ZO_DefaultButton")
--    btn.open:SetAnchor(TOPLEFT, ZO_AlchemyTopLevelInventory, TOPLEFT, 100, 15)
--    btn.open:SetWidth(150)
--    btn.open:SetText("Alchemist")
--    btn.open:SetHidden(true)
--    btn.open:SetHandler("OnClicked", function(self) btn.openAlch()
--    end)
--
--    function btn.openAlch()
--        Alchemist.control.twl:SetHidden(false)
--        btn.open:SetHidden(true)
--    end
--
--    function btn.closeAlch()
--        Alchemist.control.twl:SetHidden(true)
--        btn.open:SetHidden(false)
--    end
--end


--function Alchy:print_combinations()
--    local inventory = Alchemist.Inventory:new()
--
--self.tbl = {}
--
--- -    self.scrollList = self:CreateScrollList()
--
-- local entryList = ZO_ScrollList_GetDataList(self.scrollList)
-- local gender = 1
--
-- if not self.tbl[gender] then
-- self.tbl[gender] = {}
-- end
--
-- for i = 1, 15 do
--
-- table.insert(self.tbl[gender], stuff)
-- end
--
-- for i = 1, #self.tbl[gender] do
--
-- local entry = ZO_ScrollList_CreateDataEntry(1, self.tbl[gender][i])
-- table.insert(entryList, entry)
-- end
--
-- if not self.scrollList == nil then
-- ZO_ScrollList_Commit(self.scrollList)
-- end
----
----
---- for gender = GENDER_FEMALE, GENDER_MALE do
---- local currentRankPoints = 0
---- local numRanks = -1
----
---- for rank=0, 100 do
---- local subRankStartsAt, nextSubRankAt, rankStartsAt, nextRankAt  = GetAvARankProgress(currentRankPoints)
---- numRanks = numRanks + 1
---- currentRankPoints = nextRankAt+1
----
---- local rankName = zo_strformat(SI_STAT_RANK_NAME_FORMAT, GetAvARankName(gender, rank))
---- local rankIcon = GetAvARankIcon(rank)
----
---- if not rankName or rankName == ""  or nextRankAt == currentRankPoints then
---- break
---- end
----
----
---- if not self.rankInfo[gender] then
---- self.rankInfo[gender] = {}
---- end
---- local data = {["rankNum"] = numRanks, ["startsAt"] = rankStartsAt, ["endsAt"] = (nextRankAt-1), ["rankName"] = rankName, ["rankIcon"] = rankIcon }
---- table.insert(self.rankInfo[gender], data)
---- end
---- end
----
----
---- local entryList = ZO_ScrollList_GetDataList(self.scrollList)
---- local gender = GENDER_MALE
----
---- for rank=1, #self.rankInfo[gender] do
---- local entry = ZO_ScrollList_CreateDataEntry(1, PVP_RANKS.rankInfo[gender][rank])
---- table.insert(entryList, entry)
---- end
----
---- ZO_ScrollList_Commit(self.scrollList)
----
----
---- inventory:populate_from_control(ALCHEMY["inventory"])
----
---- local num_reagent_slots = Alchemist.get_num_reagent_slots()
---- local combinations = Alchemist.Algorithm.get_optimal_combinations(inventory, num_reagent_slots)
----
---- local SI = Alchemist.SI
----
----
----
---- if #combinations == 0 then
---- Alchemist.control.twl:AddText(SI.get(SI.NO_DISCOVERIES_AVAILABLE), Red, Green, Blue)
---- -- mw:add_message())
---- else
----
---- Alchemist.control.twl:AddText(string.format(SI.get(SI.COMBINATIONS_AVAILABLE .. #combinations)), Red, Green, Blue)
---- for _, combination in pairs(combinations) do
---- Alchemist.control.twl:AddText("\n")
---- Alchemist.control.twl:AddText(SI.get(SI.COMBINE_THE_FOLLOWING))
----
---- table.sort(combination.reagents, function(a, b) return a.name < b.name end)
---- for _, reagent in pairs(combination.reagents) do
---- Alchemist.control.twl:AddText("- |c00ff00" .. reagent.name)
---- end
----
---- Alchemist.control.twl:AddText(SI.get(SI.TO_GET_THE_FOLLOWING_DISCOVERIES))
----
---- table.sort(combination.discoveries, function(a, b) return a.reagent.name < b.reagent.name end)
---- for _, discovery in pairs(combination.discoveries) do
---- Alchemist.control.twl:AddText("- |c9999ff" .. discovery.reagent.name .. ": " .. discovery.trait)
---- end
---- end
---- end
-- end
function Alchy:get_num_reagent_slots()
    --local has_three_slot = not ZO_AlchemyTopLevelSlotContainerReagentSlot3:IsControlHidden()
    --return has_three_slot and 3 or 2
    --
    -- TODO: The current algorithm can't handle three slots, not sure why I didn't see that
    -- before, but if you have all 18 reagents, there'll be (18 * 17 * 16) + (18 * 17) = 5202
    -- combinations. My computer can handle that, but some computers will probably have a
    -- bad time!

    return 2
end





--Battries
-- table_keys_to_list({a = 1, b = 2}) -> {a, b}
local function table_keys_to_list(tbl)
    local ret = {}
    for key, _ in pairs(tbl) do
        table.insert(ret, key)
    end
    return ret
end

-- num_items_in_table({2, 4, 6}) -> 3
local function num_items_in_table(tbl)
    n = 0
    for _ in pairs(tbl) do
        n = n + 1
    end
    return n
end

-- element_is_in_table(2, {1, 3, 5}) -> false
local function element_is_in_table(item, tbl)
    for _, value in pairs(tbl) do
        if value == item then
            return true
        end
    end
    return false
end

-- Stolen from http://lua-users.org/wiki/TableUtils
function combinations(lst, n)
    local a, number, select, newlist
    newlist = {}
    number = #lst
    select = n
    a = {}
    for i = 1, select do
        a[#a + 1] = i
    end
    newthing = {}
    while (1) do
        local newrow = {}
        for i = 1, select do
            newrow[#newrow + 1] = lst[a[i]]
        end
        newlist[#newlist + 1] = newrow
        i = select
        while (a[i] == (number - select + i)) do
            i = i - 1
        end
        if (i < 1) then break
        end
        a[i] = a[i] + 1
        for j = i, select do
            a[j] = a[i] + j - i
        end
    end
    return newlist
end

local BufferTable = {}
function Alchy:BufferReached(key, buffer)
    if key == nil then return
    end
    if BufferTable[key] == nil then BufferTable[key] = {}
    end

    BufferTable[key].buffer = buffer or 15
    BufferTable[key].now = GetFrameTimeSeconds()
    if BufferTable[key].last == nil then BufferTable[key].last = BufferTable[key].now
    end
    BufferTable[key].diff = BufferTable[key].now - BufferTable[key].last
    BufferTable[key].eval = BufferTable[key].diff >= BufferTable[key].buffer
    if BufferTable[key].eval then BufferTable[key].last = BufferTable[key].now
    end
    return BufferTable[key].eval
end



EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_ADD_ON_LOADED, on_addon_load)
SLASH_COMMANDS["/damn"] = function(self) Alchemist:DoSomething()
end
SLASH_COMMANDS["/b"] = function(self) Alchemist:blah(Alchemist.self)
end

