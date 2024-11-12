local init = function() 

    if not storage.player_data then 
        storage.player_data = {}
    end

    if game.forces["player"].technologies["modular-armor"].researched then 
        game.forces["player"].recipes["teleportation-equipment"].enabled = true 
    else
        for _, player in pairs(game.players) do 
            player.set_shortcut_available("teleport-player", false)
        end
    end

end

local on_load = function()

    data = storage.player_data or data
    storage.player_data = data

end

local get_distance = function(pos1, pos2)

    local x = pos1.x - pos2.x
    local y = pos1.y - pos2.y

    return (x * x + y * y) ^ 0.5
end

-- local teleportation_equipment_inserted = function(event)

--     if event.equipment.name ~= "teleportation-equipment" then return end

--     local player = game.get_player(event.player_index)

--     if not storage.player_data[player.index] then
--         storage.player_data[player.index][event.equipment.unique_id] = event.equipment
--     end

--     if player and event.grid.find("teleportation-equipment") then
--         player.set_shortcut_available("teleport-player", true)
--     end
-- end

local teleport_equipment_inserted = function(event)

    if event.equipment.name ~= "teleportation-equipment" then return end

    local player = game.get_player(event.player_index)

    if event.grid.find("teleportation-equipment") then 
        player.set_shortcut_available("teleport-player", true)
    end

    if player.cheat_mode then 
        event.equipment.energy = event.equipment.max_energy
    end

    storage.player_data[event.player_index] = player
 
end

local teleportation_equipment_removed = function(event)
    if event.equipment ~= "teleportation-equipment" then return end

    local player = game.get_player(event.player_index)

    if player and not event.grid.find("teleportation-equipment") then
        player.set_shortcut_available("teleport-player", false)
    end
end

local teleport_player = function(event)

    local player = game.get_player(event.player_index)

    if player.character and player.character.grid and player.character.grid.find("teleportation-equipment") and not player.driving then 

        local charged = true
        local max_teleport_distance = 0

        for _, equipment in pairs(player.character.grid.equipment) do 

            if equipment.name == "teleportation-equipment" then 

                if equipment.energy < equipment.max_energy then 
                    charged = false
                else 
                    max_teleport_distance = max_teleport_distance + settings.get_player_settings(player.index)["max-teleportation-distance"].value
                end

            end        
        end

        if charged then 

            if player and get_distance(player.position, event.cursor_position) < max_teleport_distance then 

                player.play_sound({ path = "teleportation-sound", volume_modifier = 0.75 })
                rendering.draw_animation({animation = "teleportation-effect", target = player.character, surface = player.character.surface, time_to_live=60})
                player.character.teleport(event.cursor_position)
                player.set_shortcut_available("teleport-player", false)

                for _, equipment in pairs(player.character.grid.equipment) do 

                    if equipment.name == "teleportation-equipment" and not player.cheat_mode then 
                        equipment.energy = 0
                    end

                end
            else
                player.create_local_flying_text{create_at_cursor = true, text = {"", "Teleport Coordinates too far away"}, speed = 0.1}
            end

            if settings.global["teleportation-message"].value then 
                game.print({"", string.format("Player %s teleported to: [gps= %d, %d]", player.name, player.position.x, player.position.y)})
            end

        else
            player.create_local_flying_text{create_at_cursor = true, text = {"", "Equipment needs to be fully charged for teleportation"}, speed = 0.1}
        end
    elseif player.driving then 
        player.create_local_flying_text{create_at_cursor = true, text = {"" ,"Can't teleport while driving"}, speed = 0.1}
    elseif player.character and player.character.grid and not player.character.grid.find("teleportation-equipment") then
        player.create_local_flying_text{create_at_cursor = true, text = {"", "No teleportation module equipped"}, speed = 0.1}
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

    for _, player in pairs(storage.player_data) do

        player.set_shortcut_available("teleport-player", false)

        local charged = true

        if player.character and player.character.grid then 

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

end

script.on_init(init)

script.on_event("teleport-player", teleport_player)
script.on_event(defines.events.on_lua_shortcut, give_capsule)
script.on_event(defines.events.on_player_used_capsule, used_capsule)
script.on_event(defines.events.on_player_cursor_stack_changed, remove_capsule)
script.on_event(defines.events.on_player_placed_equipment, teleport_equipment_inserted)
script.on_event(defines.events.on_player_removed_equipment, teleport_equipment_removed)

script.on_nth_tick(60, check_charge_status)