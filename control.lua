local init = function() 

    if not global.player_data then 
        global.player_data = {}
    end

    if game.forces["player"].technologies["modular-armor"].researched then 
        game.forces["player"].recipes["teleportation-equipment"].enabled = true 
    end

end

local get_distance = function(pos1, pos2)
    
    local px = pos1.x - pos2.x
    local py = pos1.y - pos2.y

    return (px * px + py * py) ^ 0.5

end

local teleport_equipment_inserted = function(event)

    if event.equipment.name ~= "teleportation-equipment" then return end

    local player = game.get_player(event.player_index)

    if event.grid.find("teleportation-equipment") then 
        player.set_shortcut_available("teleport-player", true)
    end

    global.player_data[event.player_index] = player
 
end

local teleport_equipment_removed = function(event)

    if event.equipment ~= "teleportation-equipment" then return end

    local player = game.get_player(event.player_index)

    if not event.grid.find("teleportation-equipment") then 
        player.set_shortcut_available("teleport-player", false)
        global.player_data[event.player_index] = player
    end

end

local teleport_player = function(event)

    local player = game.get_player(event.player_index)

    if player.character.grid and player.character.grid.find("teleportation-equipment") and not player.driving then 

        local charged = true
        local max_teleport_distance = 0

        for _, equipment in pairs(player.character.grid.equipment) do 

            if equipment.name == "teleportation-equipment" then 

                if equipment.energy < equipment.max_energy then 
                    charged = false 
                else 
                    max_teleport_distance = max_teleport_distance + settings.player["max-teleportation-distance"].value
                end

            end        
        end

        if charged then 

            if player and get_distance(player.position, event.cursor_position) < max_teleport_distance then 

                player.play_sound({ path = "teleportation-sound", volume_modifier = 0.75 })
                rendering.draw_animation({animation = "teleportation-effect", target = player.character, surface = player.character.surface, time_to_live=60})
                player.teleport(event.cursor_position)
                player.set_shortcut_available("teleport-player", false)

                for _, equipment in pairs(player.character.grid.equipment) do 

                    if equipment.name == "teleportation-equipment" then 
                        equipment.energy = 0
                    end

                end
            end

            if settings.global["teleportation-message"].value then 
                game.print({"", string.format("Player %s teleported to: [gps= %d, %d]", player.name, player.position.x, player.position.y)})
            end

        else
            player.print("Equipment needs to be fully charged for teleportation")
        end
    end

end

local give_capsule = function(event)

    if event.prototype_name ~= "teleport-player" then return end

    local player = game.get_player(event.player_index)

    if player.clear_cursor() then 
        player.cursor_stack.set_stack{name = "teleportation-capsule", count = 1}
    end 

end

local used_capsule = function(event) 

    if event.item.name ~= "teleportation-capsule" then return end

    local custom_event = { player_index = event.player_index, cursor_position = event.position }

    teleport_player(custom_event)

end

local remove_capsule = function(event) 

    local player = game.get_player(event.player_index) 

	for i=1, #player.get_main_inventory() do
		if player.get_main_inventory()[i].valid_for_read and player.get_main_inventory()[i].name == "teleportation-capsule" then
			player.get_main_inventory()[i].clear()
		end
	end

end

local check_charge_status = function()

    for _, player in pairs(global.player_data) do 

        local charged = true

        for _, equipment in pairs(player.character.grid.equipment) do 

            if equipment.name == "teleportation-equipment" then 

                if equipment.energy < equipment.max_energy then 
                    charged = false 
                end
            end        
        end

        if charged and not player.is_shortcut_available("teleport-player") then 
            player.set_shortcut_available("teleport-player", true)
        end

    end

end

script.on_init(init)

script.on_event("teleport-player", teleport_player)
script.on_event(defines.events.on_lua_shortcut, give_capsule)
script.on_event(defines.events.on_player_used_capsule, used_capsule)
script.on_event(defines.events.on_player_cursor_stack_changed, remove_capsule)
script.on_event(defines.events.on_player_placed_equipment, teleport_equipment_inserted)
script.on_event(defines.events.on_player_removed_equipment, teleport_equipment_removed)

script.on_nth_tick(60, check_charge_status)