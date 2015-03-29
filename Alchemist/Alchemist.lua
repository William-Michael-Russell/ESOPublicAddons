local LL = LibStub('LibLuminary', 1)
if (not LL) then return end


local config = {
    addonName = "Alchemist",
    anchorTargetControl = ZO_AlchemyTopLevelInvenotry,
    width = 450,
    height = 400,
}

local alchemistControl = LL:init(config)


Alchemist = {
    version = "1.6.5.0",
}


local function on_start_crafting(event_type, crafting_type)
    if crafting_type == CRAFTING_TYPE_ALCHEMY then
        alchemistControl:SetHidden(false)
        Alchemist.print_combinations()
    end
end

local function on_end_crafting(event_type, crafting_type)
    alchemistControl:SetHidden(true)
end

local function on_craft_started(event_type, crafting_type)
    if crafting_type == CRAFTING_TYPE_ALCHEMY then
    end
end

local function on_craft_completed(event_type, crafting_type)
    if crafting_type == CRAFTING_TYPE_ALCHEMY then
        Alchemist.print_combinations()
    end
end

local function on_addon_load(eventCode, addOnName)
    if addOnName == "Alchemist" then
        Alchemist.initialize()
    end
end



function setupAdditionalUI()
    local btn = {}
     btn.close = CreateControlFromVirtual("AlchClose", alchemistControl, "ZO_DefaultButton")
    btn.close:SetAnchor(BOTTOMRIGHT, alchemistControl, TOPRIGHT, 0, 40)
    btn.close:SetWidth(150)
    btn.close:SetText("Close")
    btn.close:SetHandler("OnClicked", function(self) btn.closeAlch()
    end)


    btn.open = CreateControlFromVirtual("AlchOpen", ZO_AlchemyTopLevelInventory, "ZO_DefaultButton")
    btn.open:SetAnchor(TOPLEFT, ZO_AlchemyTopLevelInventory, TOPLEFT, 100, 15)
    btn.open:SetWidth(150)
    btn.open:SetText("Alchemist")
    btn.open:SetHidden(true)
    btn.open:SetHandler("OnClicked", function(self) btn.openAlch()
    end)

     function btn.openAlch()
        alchemistControl:SetHidden(false)
        btn.open:SetHidden(true)
    end

     function btn.closeAlch()
        alchemistControl:SetHidden(true)
        btn.open:SetHidden(false)
    end
end



function Alchemist:initialize()

    EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_CRAFTING_STATION_INTERACT, on_start_crafting)
    EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_END_CRAFTING_STATION_INTERACT, on_end_crafting)

    EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_CRAFT_STARTED, on_craft_started)
    EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_CRAFT_COMPLETED, on_craft_completed)
    setupAdditionalUI()
end

function Alchemist.print_combinations()
    local inventory = Alchemist.Inventory.new()
    inventory:populate_from_control(ALCHEMY["inventory"])

    local num_reagent_slots = Alchemist.get_num_reagent_slots()
    local combinations = Alchemist.Algorithm.get_optimal_combinations(inventory, num_reagent_slots)

    local SI = Alchemist.SI



    if #combinations == 0 then
        alchemistControl:AddText(SI.get(SI.NO_DISCOVERIES_AVAILABLE), Red, Green, Blue)
        --        mw:add_message())
    else

        alchemistControl:AddText(string.format(SI.get(SI.COMBINATIONS_AVAILABLE .. #combinations)), Red, Green, Blue)
        alchemistControl:AddText("")
        for _, combination in pairs(combinations) do
            alchemistControl:AddText("\n" ..SI.get(SI.COMBINE_THE_FOLLOWING))

            table.sort(combination.reagents, function(a, b) return a.name < b.name end)
            for _, reagent in pairs(combination.reagents) do
                alchemistControl:AddText("- |c00ff00" .. reagent.name)
            end

            alchemistControl:AddText(SI.get(SI.TO_GET_THE_FOLLOWING_DISCOVERIES))

            table.sort(combination.discoveries, function(a, b) return a.reagent.name < b.reagent.name end)
            for _, discovery in pairs(combination.discoveries) do
                alchemistControl:AddText("- |c9999ff" .. discovery.reagent.name .. ": " .. discovery.trait)
            end
            alchemistControl:AddText("")
        end
    end
end

function Alchemist.get_num_reagent_slots()
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
        if (i < 1) then break end
        a[i] = a[i] + 1
        for j = i, select do
            a[j] = a[i] + j - i
        end
    end
    return newlist
end

Alchemist.Batteries = {
    table_keys_to_list = table_keys_to_list,
    num_items_in_table = num_items_in_table,
    combinations = combinations,
    element_is_in_table = element_is_in_table,
}




EVENT_MANAGER:RegisterForEvent("Alchemist", EVENT_ADD_ON_LOADED, on_addon_load)
