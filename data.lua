local item_sounds = require("__base__.prototypes.item_sounds")

data:extend({
    {
        type = "custom-input",
        name = "teleport-player",
        localised_name = "Teleport Player",
        key_sequence = "CONTROL + SHIFT + T",
        action = "lua",
        consuming = "none",
    },
    {
        type = "battery-equipment",
        name = "teleportation-equipment",
        categories = {"armor"},
        sprite = {
            filename = "__TeleportationEquipment__/graphics/teleportation-equipment.png",
            flags = {"icon"},
            priority = "extra-high-no-scale",
            size = 128,
            scale = 0.5
        },
        shape = {
            width = 2,
            height = 2,
            type = "full"
        },
        energy_source = {
            type = "electric",
            buffer_capacity = "1.5MJ",
            usage_priority = "primary-input",
            input_flow_limit = "750kW"
        },
    },
    {
        type = "capsule",
        name = "teleportation-capsule",
        icon = "__TeleportationEquipment__/graphics/teleportation-equipment.png",
        flags = {"only-in-cursor", "not-stackable", "spawnable"},    
        capsule_action = {
            type = "use-on-self",
            attack_parameters = {
                type = "projectile",
                ammo_category = "capsule",
                cooldown = 30,
                range = 1000,
                -- sound = {
                --     filename = "__TeleportationEquipment__/graphics/teleport.ogg", 
                --     volume = 0.7
                -- },
                ammo_type =
                {
                    target_type = "position",
                    action =
                    {
                        {
                            type = "direct",
                            action_delivery = {
                                type = "instant",
                                target_effects = {
                                    {
                                        type = "damage",
                                        damage = { type = "physical", amount = 0 }
                                    }
                                }
                            }
                        }
                    }
                },
                animation = {
                    name = "teleportation-effect",
                    filename = "__TeleportationEquipment__/graphics/teleportation_effect.png",
                    width = 256,
                    height = 256,
                    line_length = 4,
                    frame_count = 15,
                    animation_speed = 0.5,
                    draw_as_glow = true,
                },
            }
        },
        subgroup = "spawnables",
        order = "h[teleport]",
        stack_size = 1,
        inventory_move_sound = item_sounds.electric_small_inventory_move,
        pick_sound = item_sounds.electric_small_inventory_pickup,
        drop_sound = item_sounds.electric_small_inventory_move,
    },
    {
        type = "item",
        name = "teleportation-equipment",
        icon = "__TeleportationEquipment__/graphics/teleportation-equipment.png",
        place_as_equipment_result = "teleportation-equipment",
        subgroup = "equipment",
        stack_size = 20,
        inventory_move_sound = item_sounds.electric_large_inventory_move,
        pick_sound = item_sounds.electric_large_inventory_pickup,
        drop_sound = item_sounds.electric_large_inventory_move,
    },
    {
        type = "recipe",
        name = "teleportation-equipment",
        enabled = false,
        energy_required = 10,
        ingredients = 
        {
            { type = "item", name = "battery", amount = 5 },
            { type = "item", name = "iron-plate", amount = 5 },
            { type = "item", name = "copper-plate", amount = 5 },
            { type = "item", name = "advanced-circuit", amount = 5 },
        },
        results = {{ type = "item", name = "teleportation-equipment", amount = 1 }}
    },
    {
        type = "technology",
        name = "teleportation-equipment",
        icon_size = 256,
        icons = util.technology_icon_constant_equipment("__TeleportationEquipment__/graphics/teleportation-equipment-technology.png"),
        prerequisites = { "solar-panel-equipment" },
        effects =
        {
            {
                type = "unlock-recipe",
                recipe = "teleportation-equipment",
            }
        },
        unit = {
            count = 150,
            time = 15,
            ingredients = 
            {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "military-science-pack", 1 },
            },
        }
    },
    {
        type = "animation",
        name = "teleportation-effect",
        filename = "__TeleportationEquipment__/graphics/teleportation_effect.png",
        width = 256,
        height = 256,
        line_length = 4,
        frame_count = 16,
        animation_speed = 0.5,
        scale = 0.5,
        draw_as_glow = true,
    },
    {
        type = "sound",
        name = "teleportation-sound",
        category = "game-effect",
        filename = "__TeleportationEquipment__/graphics/teleport.ogg",
    },
    {
        type = "shortcut",
        name = "teleport-player",
        order = "a[teleport]",
        action = "lua",
        -- action = "spawn-item",
        -- item_to_spawn = "teleportation-capsule",
        associated_control_input = "teleport-player",
        unavailable_until_unlocked = true,
        technology_to_unlock = "teleportation-equipment",
        icon = "__TeleportationEquipment__/graphics/icons/teleport-player-x32.png",
        icon_size = 32,
        small_icon = "__TeleportationEquipment__/graphics/icons/teleport-player-x24.png",
        small_icon_size = 24,
    }

})
