data:extend({
    {
        type = "bool-setting",
        name = "global-teleportation-message",
        setting_type = "runtime-global",
        default_value = false
    },
    {
        type = "string-setting",
        name = "required-energy-to-teleport",
        setting_type = "startup",
        default_value = "750kW",
    },
    {
        type = "double-setting",
        name = "max-teleportation-distance",
        setting_type = "runtime-global",
        default_value = 1000,
        minimum_value = 1,
        maximum_value = 10000,
    },
})