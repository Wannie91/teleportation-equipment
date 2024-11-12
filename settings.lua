-- data:extend({
--     {
--         type = "bool-setting",
--         name = "global-teleportation-message",
--         setting_type = "runtime-global", 
--         default_value = false
--     },
--     {
--         type = "double-setting",
--         name = "teleportation-energy-requierement",
--         setting_type = "runtime-global",
--         default_value = ""
--     }


-- })




data:extend({
    { 
        type = "bool-setting",
        name = "teleportation-message",
        setting_type = "runtime-global",
        default_value = false
    },
    {
        type = "double-setting", 
        name = "max-teleportation-distance", 
        setting_type = "runtime-per-user",
        default_value = 1000,
        minimum_value = 1,
        maximum_value = 10000
    },
    { 
        type = "double-setting",
        name = "teleport-module-recharge-speed",
        setting_type = "runtime-global",
        default_value = 100,
        minimum_value = 100,
        maximum_value  = 500,
    }
})