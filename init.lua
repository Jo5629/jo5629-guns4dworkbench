guns4dworkbench = {
    registered_guns = {},
    registered_mags = {},
    registered_ammo = {},
    registered_crafts = {},
}

local modpath = minetest.get_modpath(minetest.get_current_modname())

dofile(modpath .. "/api.lua")
dofile(modpath .. "/workbench.lua")

if minetest.get_modpath("default") then
    local steel = "default:steel_ingot"
    local wood = "group:wood"
    local stick = "default:stick"
    minetest.register_craft({
        type = "shaped",
        output = "guns4dworkbench:Workbench",
        recipe = {
            {steel, steel, steel},
            {wood, wood, wood},
            {stick, "", stick},
        }
    })
    if minetest.get_modpath("guns4d_pack_1") and minetest.get_modpath("tnt") then
        dofile(modpath .. "/guns4d_pack_1.lua")
    end
end