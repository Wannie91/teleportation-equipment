data:extend({
    {
        type = "bool-setting",
        name = "global-teleportation-message",
        setting_type = "runtime-global",
        default_value = false
    },
    {
        type = "double-setting",
        name = "required-energy-to-teleport",
        setting_type = "startup",
        minimum_value = 1,
        maximum_value = 1500,
        default_value = 20,
    },
    {
        type = "double-setting",
        name = "teleportation-recharging-speed",
        setting_type = "startup",
        minimum_value = 1000,
        maximum_value = 10000,
        default_value = 5000,
    },
    {
        type = "double-setting",
        name = "max-teleportation-distance",
        setting_type = "startup",
        default_value = 500,
        minimum_value = 1,
        maximum_value = 1000,
    },
})