local init = function()

    if not storage.player_data then
        storage.player_data = {}
    end

    for _, force in pairs(game.forces) do
        if force.technologies["modular-armor"].researched then
            force.recipes["teleportation-equipment"].enabled = true
        else
            -- for _, player in pairs(force) do
                -- player.set_shortcut_available("teleport-player", false)
            -- end
        end
    end

end

local on_load = function()

    data = storage.player_data or data
    storage.player_data = data

end

local get_distance = function(pos1, pos2)

    local x = pos2.x - pos1.x
    local y = pos1.y - pos1.y

    return math.sqrt(x * x + y * y )

end

local teleport_player = function(event)

    local player = game.get_player(event.player_index)
    local character = player.character

    if player and player.driving then
        player.create_local_flying_text{create_at_cursor = true, text = {"" ,"Can't teleport while driving"}, speed = 0.1}
        return
    end

    if character and character.grid then

        local max_teleportation_distance = 0
        local has_teleportation_equipped = false

        for _, equipment in pairs(character.grid.equipment) do
            if equipment.name == "teleportation-equipment" then
                has_teleportation_equipped = true

                if equipment.energy >= equipment.prototype.attack_parameters.ammo_type.energy_consumption then
                    max_teleportation_distance = max_teleportation_distance + equipment.prototype.attack_parameters.range
                end
            end
        end

        if has_teleportation_equipped then

            if max_teleportation_distance ~= 0 then

                if get_distance(player.position, event.cursor_position) <= max_teleportation_distance then
                    character.teleport(event.cursor_position)
                    rendering.draw_animation({animation = "teleportation-effect", target = player.character, surface = player.character.surface, time_to_live=60})
                    player.play_sound({path = "teleportation-sound", volume_modifier = 0.75})

                    for _, equipment in pairs(player.character.grid.equipment) do
                        if equipment.name == "teleportation-equipment" then
                            equipment.energy = equipment.energy - equipment.prototype.attack_parameters.ammo_type.energy_consumption
                        end
                    end

                    if settings.global["global-teleportation-message"].value then
                        game.print({"", string.format("Player %s teleported to: [gps= %d, %d]", player.name, player.position.x, player.position.y)})
                    end

                else
                    player.create_local_flying_text{create_at_cursor = true, text = {"", "Teleportation Coordinates too far away"}, speed = 0.1}
                end

            else
                player.create_local_flying_text{create_at_cursor = true, text = {"", "Not enough power to teleport"}, speed = 0.1}
            end
        else
            player.create_local_flying_text{create_at_cursor = true, text = {"", "No teleportation module equipped"}, speed = 0.1}
        end
    end

end

local used_capsule = function(event)

    if event.item.name ~= "teleportation-capsule" then return end

    local player = event.player_index
    local custom_event = { player_index = event.player_index, cursor_position = event.position}

    teleport_player(custom_event)
end

script.on_init(init)

script.on_event("teleport-player", teleport_player)
script.on_event(defines.events.on_player_used_capsule, used_capsule)