-- all reagents {{{
local SI = Alchemist.SI

local all_reagents = {
    [SI.get(SI.BLESSED_THISTLE)] = {
        SI.get(SI.INCREASE_WEAPON_POWER),
        SI.get(SI.RAVAGE_HEALTH),
        SI.get(SI.RESTORE_STAMINA),
        SI.get(SI.SPEED),
    },
    [SI.get(SI.BLUE_ENTOLOMA)] = {
        SI.get(SI.INVISIBLE),
        SI.get(SI.LOWER_SPELL_POWER),
        SI.get(SI.RAVAGE_MAGICKA),
        SI.get(SI.RESTORE_HEALTH),
    },
    [SI.get(SI.BUGLOSS)] = {
        SI.get(SI.INCREASE_SPELL_RESIST),
        SI.get(SI.LOWER_SPELL_POWER),
        SI.get(SI.RESTORE_HEALTH),
        SI.get(SI.RESTORE_MAGICKA),
    },
    [SI.get(SI.COLUMBINE)] = {
        SI.get(SI.RESTORE_HEALTH),
        SI.get(SI.RESTORE_MAGICKA),
        SI.get(SI.RESTORE_STAMINA),
        SI.get(SI.UNSTOPPABLE),
    },
    [SI.get(SI.CORN_FLOWER)] = {
        SI.get(SI.DETECTION),
        SI.get(SI.INCREASE_SPELL_POWER),
        SI.get(SI.RAVAGE_HEALTH),
        SI.get(SI.RESTORE_MAGICKA),
    },
    [SI.get(SI.DRAGONTHORN)] = {
        SI.get(SI.INCREASE_WEAPON_POWER),
        SI.get(SI.LOWER_ARMOR),
        SI.get(SI.RESTORE_STAMINA),
        SI.get(SI.WEAPON_CRIT),
    },
    [SI.get(SI.EMETIC_RUSSULA)] = {
        SI.get(SI.RAVAGE_HEALTH),
        SI.get(SI.RAVAGE_MAGICKA),
        SI.get(SI.RAVAGE_STAMINA),
        SI.get(SI.STUN),
    },
    [SI.get(SI.IMP_STOOL)] = {
        SI.get(SI.INCREASE_ARMOR),
        SI.get(SI.LOWER_WEAPON_CRIT),
        SI.get(SI.LOWER_WEAPON_POWER),
        SI.get(SI.RAVAGE_STAMINA),
    },
    [SI.get(SI.LADYS_SMOCK)] = {
        SI.get(SI.INCREASE_SPELL_POWER),
        SI.get(SI.LOWER_SPELL_RESIST),
        SI.get(SI.RESTORE_MAGICKA),
        SI.get(SI.SPELL_CRIT),
    },
    [SI.get(SI.LUMINOUS_RUSSULA)] = {
        SI.get(SI.LOWER_WEAPON_POWER),
        SI.get(SI.RAVAGE_STAMINA),
        SI.get(SI.REDUCE_SPEED),
        SI.get(SI.RESTORE_HEALTH),
    },
    [SI.get(SI.MOUNTAIN_FLOWER)] = {
        SI.get(SI.INCREASE_ARMOR),
        SI.get(SI.LOWER_WEAPON_POWER),
        SI.get(SI.RESTORE_HEALTH),
        SI.get(SI.RESTORE_STAMINA),
    },
    [SI.get(SI.NAMIRAS_ROT)] = {
        SI.get(SI.INVISIBLE),
        SI.get(SI.SPEED),
        SI.get(SI.SPELL_CRIT),
        SI.get(SI.UNSTOPPABLE),
    },
    [SI.get(SI.NIRNROOT)] = {
        SI.get(SI.INVISIBLE),
        SI.get(SI.LOWER_SPELL_CRIT),
        SI.get(SI.LOWER_WEAPON_CRIT),
        SI.get(SI.RAVAGE_HEALTH),
    },
    [SI.get(SI.STINKHORN)] = {
        SI.get(SI.INCREASE_WEAPON_POWER),
        SI.get(SI.LOWER_ARMOR),
        SI.get(SI.RAVAGE_HEALTH),
        SI.get(SI.RAVAGE_STAMINA),
    },
    [SI.get(SI.VIOLET_COPRINUS)] = {
        SI.get(SI.INCREASE_SPELL_POWER),
        SI.get(SI.LOWER_SPELL_RESIST),
        SI.get(SI.RAVAGE_HEALTH),
        SI.get(SI.RAVAGE_MAGICKA),
    },
    [SI.get(SI.WATER_HYACINTH)] = {
        SI.get(SI.RESTORE_HEALTH),
        SI.get(SI.SPELL_CRIT),
        SI.get(SI.STUN),
        SI.get(SI.WEAPON_CRIT),
    },
    [SI.get(SI.WHITE_CAP)] = {
        SI.get(SI.INCREASE_SPELL_RESIST),
        SI.get(SI.LOWER_SPELL_CRIT),
        SI.get(SI.LOWER_SPELL_POWER),
        SI.get(SI.RAVAGE_MAGICKA),
    },
    [SI.get(SI.WORMWOOD)] = {
        SI.get(SI.DETECTION),
        SI.get(SI.REDUCE_SPEED),
        SI.get(SI.UNSTOPPABLE),
        SI.get(SI.WEAPON_CRIT),
    },

}
-- }}}

local Inventory = {}

function Inventory.new()
    local self = {
        reagents = {}
    }
    setmetatable(self, { __index = Inventory })
    
    return self
end

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
    for i=1,select do
        a[#a+1] = i
    end
    newthing = {}
    while(1) do
        local newrow = {}
        for i = 1,select do
            newrow[#newrow + 1] = lst[a[i]]
        end
        newlist[#newlist + 1] = newrow
        i=select
        while(a[i] == (number - select + i)) do
            i = i - 1
        end
        if(i < 1) then break end
        a[i] = a[i] + 1
        for j=i, select do
            a[j] = a[i] + j - i
        end
    end
    return newlist
end


local function get_discovered_traits(reagents)
    -- compare reagents and find traits that would be discovered if these reagents was combined.
    --
    -- this is done by going through each non-discovered trait of each reagent, and see if other
    -- reagents have the same trait (discovered or not.)
    local discoveries = {}

    -- seriously lua. get `continue`.
    for _, r1 in pairs(reagents) do
        for trait, discovered in pairs(r1.traits) do
            if not discovered then
                for _, r2 in pairs(reagents) do
                    if r1 ~= r2 then
                        if r2.traits[trait] ~= nil then
                            table.insert(discoveries, {
                                reagent = r1,
                                trait = trait,
                            })
                            break
                        end
                    end
                end
            end
        end
    end

    return discoveries
end

local function get_best_combination(inventory, max_reagents)
    -- given a set of reagents (inventory), return the best possible combination, maximizing on
    -- number of new discoveries.
    --
    -- "best possible" is not theoretically optimal, but it's good enough. A better way to do this
    -- would be to implement a depth first search, that finds which combination of combinations yields
    -- the most discoveries per reagent used, overall. But I'm not planning on implementing that;
    -- the current algorithm is good enough.
    if inventory:num_reagents() < 2 then
        return
    end

    -- we score each combination to decide the best one. this scoring is done such that if we have
    -- two combinations that gets 4 discoveries, we take the one that uses the least reagents.
    -- that's about it.
    local best_score = 0
    local best_combination

    local reagent_names = inventory:get_reagent_names()
    local all_combinations = {}

    for num_reagents = 2, max_reagents do
        local combinations = combinations(reagent_names, num_reagents)
        for _, combination in pairs(combinations) do
            table.insert(all_combinations, combination)
        end
    end

    for _, reagent_names in pairs(all_combinations) do
        local reagents_combination = {}
        for _, reagent_name in pairs(reagent_names) do
            table.insert(reagents_combination, inventory:get_reagent(reagent_name))
        end

        local discoveries = get_discovered_traits(reagents_combination)

        -- we subtract #reagent_names (number of reagents used) so we use the least amount of
        -- reagents if different combinations yields the same number of discoveries.
        local score = (#discoveries * 10) - #reagent_names
        if score > best_score then
            best_score = score
            best_combination = {
                reagents = reagents_combination,
                discoveries = discoveries,
            }
        end
    end

    if best_combination and #best_combination.discoveries > 0 then
        return best_combination
    end
end


local function get_optimal_combinations(inventory, max_reagents)

    -- returns a list of combinations that can be done in order, to maximize discovery of traits.
    local ret = {}

    local combination
    repeat
        --it breaks in here.
        combination = get_best_combination(inventory, max_reagents)
        if combination then
            table.insert(ret, combination)
            d("just loggin")
            --
            for _, reagent in pairs(combination.reagents) do
                inventory:decrement_reagent_qty(reagent)
            end

            for _, discovery in pairs(combination.discoveries) do
                discovery.reagent:discover(discovery.trait)
            end
        end
    until not combination

--
    return ret
end

function Inventory:add_reagent(reagent_name, qty, known_traits, bag_id, slot_index)
    -- Adds a reagent to the current inventory. It will also add traits that we don't know about yet,
    -- and set them to "not discovered". This is indicated by the *value* in the `traits` table.
    local traits = {}

    local all_traits = all_reagents[reagent_name]
    assert(all_traits ~= nil and #all_traits == 4, string.format("'%s' is not a valid reagent.", reagent_name))

    for _, trait in pairs(all_traits) do
        assert(traits[trait] == nil, string.format("Could not find trait '%s' in reagent '%s'", trait, reagent_name))

        -- key = trait name
        -- value = is discovered
        traits[trait] = element_is_in_table(trait, known_traits)
    end

    -- This check makes sure that the player didn't have some trait in his inventory that ISN'T in all_reagents.
    for _, trait in pairs(known_traits) do
        assert(traits[trait], string.format("Trait '%s' is NOT in our list of traits for reagent '%s'. " ..
                                            "Please leaeve a comment on esoui.com with this error.", trait, reagent_name))
    end
    
    assert(self.reagents[reagent_name] == nil, string.format("Tried to add '%s', but it's already added.", reagent_name))

    local num_traits = num_items_in_table(traits)
    assert(num_traits == 4, string.format("Found %d traits; something is wrong with the reagent '%s'.", num_traits, reagent_name))

    self.reagents[reagent_name] = Alchemist.Reagent:new(reagent_name, qty, traits, bag_id, slot_index)
--
    return self.reagents[reagent_name]
end

 function Inventory:decrement_reagent_qty(reagent)
    -- will either decrement qty or remove the reagent all together.
    if reagent.qty == 1 then
        self.reagents[reagent.name] = nil
    else
        reagent.qty = reagent.qty - 1
    end
end

function Inventory:get_reagent(reagent_name)
    return self.reagents[reagent_name]
end

function Inventory:num_reagents()
    return num_items_in_table(self.reagents)
end

function Inventory:get_reagent_names()
    return table_keys_to_list(self.reagents)
end

function Inventory:populate_from_control(control)
    -- populates self.reagents using GetAlchemyItemTraits().
    local list_data = control["list"]["data"]
    for _, list_item in pairs(list_data) do
        local type_id = list_item.typeId
        if type_id == 2 then
            local reagent_data = list_item["data"]
            
            local name = reagent_data.name
            local bag_id = reagent_data.bagId
            local slot_index = reagent_data.slotIndex
            local qty = reagent_data.stackCount
      
            local t1, _, _, t2, _, _, t3, _, _, t4, _, _ = GetAlchemyItemTraits(bag_id, slot_index)
            local known_traits = {t1, t2, t3, t4}
            
            local reagent = self:add_reagent(name, qty, known_traits, bag_id, slot_index)
        end
    end
end

Alchemist.Inventory = Inventory
Alchemist.Algorithm.get_optimal_combinations = get_optimal_combinations
