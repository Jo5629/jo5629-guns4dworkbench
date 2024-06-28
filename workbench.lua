local gui = flow.widgets
local types = {"Ammo", "Mags", "Guns"}
local workbench_formspec = flow.make_gui(function(player, ctx)
    local buttons_hbox = gui.Hbox{}
    for _, type in pairs(types) do
        table.insert(buttons_hbox, gui.Button{
            label = type,
            on_event = function(player, ctx)
                ctx.selected = string.lower(type)
                return true
            end
        })
    end
    table.insert(buttons_hbox, gui.Spacer{})
    table.insert(buttons_hbox, gui.Button{
        label = "Craft",
        on_event = function(player, ctx)
            local success, reason = guns4dworkbench.player_craft_item(ctx.form["workbench_dropdown"], player)
            if not success then
                minetest.chat_send_player(player:get_player_name(), minetest.colorize("#FF0000", string.format("Unable to craft. Reason: %s", guns4dworkbench.crafting_reasons[reason])))
            end
            return true
        end,
        w = 2,
    })

    local selected = ctx.selected or "ammo"
    local dropdown_table = guns4dworkbench[string.format("registered_%s", selected)] or guns4dworkbench.registered_ammo
    local craft_table = guns4dworkbench.get_craft_for(ctx.form["workbench_dropdown"] or dropdown_table[1]) --> Somehow the item images do not get updated right away. You need to click the button twice.
    local dropdown_hbox = gui.Hbox{
        gui.Dropdown{
            name = "workbench_dropdown",
            items = dropdown_table,
            w = 5.5,
        },
        gui.Spacer{},
        gui.ItemImage{
            w = 2, h = 2,
            item_name = craft_table.output,
            tooltip = ItemStack(craft_table.output):get_short_description(),
        },
    }

    local materials_hbox = gui.Hbox{
        gui.Label{label = "Materials:", style = {font_size = "*1.5"}},
    }
    for _, item in pairs(craft_table.recipe) do
        table.insert(materials_hbox, gui.Stack{
            gui.ItemImage{
                w = 1.25, h = 1.25,
                item_name = item,
                tooltip = ItemStack(item):get_short_description(),
            },
        })
    end

    return gui.Vbox{
        gui.Label{label = "Guns4dWorkbench", align_h = "centre", style = {font = "bold", font_size = "*1.5"}},
        gui.Label{label = "You might need to click the button twice for the item images to correctly render.", w = 8, style = {font = "italic", font_size = "*0.82"}},
        buttons_hbox, dropdown_hbox, materials_hbox,
        gui.List{
            inventory_location = "current_player",
            list_name = "main",
            w = 8,
            h = 4,
        },
    }
end)

minetest.register_node("guns4dworkbench:Workbench", {
    description = "Gunsmith Workbench",
    groups = {cracky = 3},
    paramtype2 = "facedir",
    drawtype = "mesh",
    mesh = "guns4dworkbench.obj",
    tiles = {"guns4dworkbench.png"},
    visual_scale = 2,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        workbench_formspec:show(clicker)
    end
})