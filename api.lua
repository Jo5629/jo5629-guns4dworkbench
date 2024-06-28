function guns4dworkbench.register_ammocraft(name, def)
    if not def.output then def.output = name end
    table.insert(guns4dworkbench.registered_ammo, name)
    guns4dworkbench.registered_crafts[name] = def

    table.sort(guns4dworkbench.registered_ammo, function (a, b)
        return string.upper(a) < string.upper(b)
    end)
end

function guns4dworkbench.register_magcraft(name, def)
    if not def.output then def.output = name end
    table.insert(guns4dworkbench.registered_mags, name)
    guns4dworkbench.registered_crafts[name] = def

    table.sort(guns4dworkbench.registered_mags, function (a, b)
        return string.upper(a) < string.upper(b)
    end)
end

function guns4dworkbench.register_guncraft(name, def)
    if not def.output then def.output = name end
    table.insert(guns4dworkbench.registered_guns, name)
    guns4dworkbench.registered_crafts[name] = def

    table.sort(guns4dworkbench.registered_guns, function (a, b)
        return string.upper(a) < string.upper(b)
    end)
end

function guns4dworkbench.get_craft_for(name)
    return guns4dworkbench.registered_crafts[name]
end

function guns4dworkbench.is_eligible_for_craft(output, inv, listname)
    listname = listname or "main"
    local craft_def = guns4dworkbench.get_craft_for(output)
    if not craft_def then
        return false
    end
    local count = 0
    for _, input in pairs(craft_def.recipe) do
        if inv:contains_item(listname, ItemStack(input)) then
            count = count + 1
        end
    end
    if count >= #craft_def.recipe then
        return true
    end
    return false
end

guns4dworkbench.crafting_reasons = {
    [1] = "Insufficient items.",
    [2] = "No inventory space.",
    [3] = "Successful."
}


--> Function for any automation. (Hopefully)
function guns4dworkbench.craft_item(output, inv, listname)
    local eligible = guns4dworkbench.is_eligible_for_craft(output, inv, listname)
    if eligible then
        local craft_table = guns4dworkbench.get_craft_for(output)

        local output_stack = ItemStack(craft_table.output)
        if not inv:room_for_item(listname, output_stack) then
            return false, 2
        end

        for _, input in pairs(craft_table.recipe) do
            inv:remove_item(listname, ItemStack(input))
        end
        inv:add_item(listname, output_stack)
        return true, 3
    end
    return false, 1
end

function guns4dworkbench.player_craft_item(output, player, listname)
    listname = listname or "main"
    local inv = player:get_inventory()

    local success, callback = guns4dworkbench.craft_item(output, inv, listname)
    if not success and callback == 2 then
        local craft_table = guns4dworkbench.get_craft_for(output)
        minetest.add_item(player:get_pos(), ItemStack(craft_table.output))
        return true, 3
    end
    return success, callback
end