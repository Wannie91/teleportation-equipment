data:extend({
    {
        type = "capsule", 
        name = "teleportation-capsule",
        icon = "__TeleportationEquipment__/graphics/teleportation-equipment.png",
        icon_size = 64,
        capsule_action =
        {
            type = "use-on-self",
            attack_parameters =
            {
                type = "projectile",
                activation_type = "consume",
                ammo_category = "capsule",
                cooldown = 30,
                range = 0,
                ammo_type =
                {
                    category = "capsule",
                    target_type = "position",
                    action =
                    {
                        type = "direct",
                        action_delivery =
                        {
                            type = "instant",
                            target_effects =
                            {
                                {
                                    type = "damage",
                                    damage = {type = "physical", amount = 0}
                                },
                            }
                        }
                    }
                }
            }
        },
        order = "h[teleport]",
        stack_size = 1
    },
	{
        type = "custom-input",
        name = "teleport-player",
        localized_name = "Teleport Player",
        key_sequence = "CONTROL + SHIFT + T",
        consuming = "none",
    },
	{
        type = "shortcut",
        name = "teleport-player",
        order = "a[teleport]",
        action = "lua",
        technology_to_unlock = "modular-armor",
        icon = 
        {
            filename = "__TeleportationEquipment__/graphics/icons/teleport-player-x32.png",
            flags = {"icon"},
            priority = "extra-high-no-scale",
            scale = 1,
            size = 32
        },
        small_icon = 
        {
            filename = "__TeleportationEquipment__/graphics/icons/teleport-player-x24.png",
            flags = {"icon"},
            priority = "extra-high-no-scale",
            scale = 1,
            size = 24,
        },
        disabled_icon = 
        {
            filename = "__TeleportationEquipment__/graphics/icons/teleport-player-x32-white.png",
            flags = {"icon"},
            priority = "extra-high-no-scale",
            scale = 1,
            size = 32,
        },
        disabled_small_icon = 
        {
            filename = "__TeleportationEquipment__/graphics/icons/teleport-player-x24-white.png",
            flags = {"icon"},
            priority = "extra-high-no-scale",
            scale = 1,
            size = 24
        },
    },
	{
		type = "battery-equipment",
		name = "teleportation-equipment",
		categories = {"armor"},
		take_result = "teleportation-equipment",
		sprite = 
		{
			  filename = "__TeleportationEquipment__/graphics/teleportation-equipment.png",
			  width = 64,
			  height = 64,
			  priority = "medium",
			  hr_version =
			  {
				filename = "__TeleportationEquipment__/graphics/hr-teleportation-equipment.png",
				width = 128,
				height = 128,
				priority = "medium",
				scale = 0.5
			  }
		},
		shape = 
		{
			width = 2, 
			height = 2,
			type = "full",
		},
		energy_source = 
		{
			type = "electric",
			buffer_capacity = "750KJ",
			usage_priority = "primary-input",
		},
	},
	{
	    type = "item",
		name = "teleportation-equipment",
		icon = "__TeleportationEquipment__/graphics/teleportation-equipment.png",
		icon_size = 64, icon_mipmaps = 4,
		placed_as_equipment_result = "teleportation-equipment",
		subgroup = "equipment",
		order = "e[robotics]-g[teleportation-equipment]",
		default_request_amount = 1,
		stack_size = 20
    },
	{
        type = "recipe",
        name = "teleportation-equipment",
        enabled = false,
        energy_required = 15,
        ingredients = 
        {
            {"battery", 5},
			{"iron-plate", 5},
			{"copper-plate", 5},
            {"advanced-circuit", 5},
        },
        result = "teleportation-equipment",
    },
    {
        type = "sound",
        name = "teleportation-sound",
        category = "game-effect",
        filename = "__TeleportationEquipment__/graphics/teleport.ogg",
    },
    {
        type = "technology",
        name = "teleportation-equipment",
        icon_size = 256,
        icon_mipmaps = 4,
        icons = util.technology_icon_constant_equipment("__TeleportationEquipment__/graphics/teleportation-equipment-technology.png"),
        prerequisites = {"solar-panel-equipment"},
        effects = {{ type = "unlock-recipe", recipe = "teleportation-equipment"}},
        unit =
        {
          count = 150,
          ingredients =
          {
            {"automation-science-pack", 1},
            {"logistic-science-pack", 1},
            {"military-science-pack", 1}
          },
          time = 15
        },
        order = "g-e-a",        
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
    }
})