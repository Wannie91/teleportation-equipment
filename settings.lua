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
        default_value = 2000,
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