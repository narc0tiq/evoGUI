require "template"

if not evogui.on_click then evogui.on_click = {} end
local sensor = ValueSensor.new("player_locations")
sensor.show_player_index = sensor:make_on_click_checkbox_handler("show_player_index")
sensor.show_position = sensor:make_on_click_checkbox_handler("show_position")
sensor.show_surface = sensor:make_on_click_checkbox_handler("show_surface")
sensor.show_direction = sensor:make_on_click_checkbox_handler("show_direction")
sensor.show_offline = sensor:make_on_click_checkbox_handler("show_offline")


function sensor:create_ui(owner)
    if owner[self.name] == nil then
        local root = owner.add{type="flow",
                               name=self.name,
                               direction="horizontal",
                               style="description_flow_style"}

        root.add{type="label", caption={self.format_key}}
        root.add{type="table", name="player_list", colspan=1}
    end
end


function sensor:settings_gui(player_index)
    local player = game.get_player(player_index)
    local sensor_settings = global.evogui[player.name].sensor_settings[self.name]
    local root_name = self:settings_root_name()

    local root = player.gui.center.add{type="frame",
                                       name=root_name,
                                       direction="vertical",
                                       caption={"sensor.player_locations.settings.title"}}
    root.add{type="checkbox", name="evogui_sensor_player_locations_checkbox_show_player_index",
             caption={"sensor.player_locations.settings.show_player_index"},
             state=sensor_settings.show_player_index}

    root.add{type="checkbox", name="evogui_sensor_player_locations_checkbox_show_position",
             caption={"sensor.player_locations.settings.show_position"},
             state=sensor_settings.show_position}

    root.add{type="checkbox", name="evogui_sensor_player_locations_checkbox_show_surface",
             caption={"sensor.player_locations.settings.show_surface"},
             state=sensor_settings.show_surface}

    root.add{type="checkbox", name="evogui_sensor_player_locations_checkbox_show_direction",
             caption={"sensor.player_locations.settings.show_direction"},
             state=sensor_settings.show_direction}

    root.add{type="checkbox", name="evogui_sensor_player_locations_checkbox_show_offline",
             caption={"sensor.player_locations.settings.show_offline"},
             state=sensor_settings.show_offline}

    root.add{type="button", name="evogui_sensor_player_locations_close", caption={"settings_close"}}
end

local function directions(source, destination)
    -- Directions to or from positionless things? Hrm.
    if not source.position or not destination.position then return {"direction.unknown"} end

    local delta_x = destination.position.x - source.position.x
    local delta_y = destination.position.y - source.position.y

    if math.abs(delta_x) < 2 and math.abs(delta_y) < 2 then return '' end

    return evogui.get_octant_name{x=delta_x, y=delta_y}
end


function sensor:update_ui(owner)
    local player = game.get_player(owner.player_index)
    local sensor_settings = global.evogui[player.name].sensor_settings[self.name]
    local gui_list = owner[self.name].player_list

    for _, p in ipairs(game.players) do
        local player_name = p.name
        if not player_name or player_name == '' then
            -- fallback to "Local Player" if this is singleplayer
            if #game.players == 1 then
                player_name = "sensor.player_locations.local_player"
            else
                if gui_list.error == nil then
                    gui_list.add{type="label", name="error", caption={"sensor.player_locations.err_no_name"}}
                end
                break
            end
        end

        if gui_list.error ~= nil then gui_list.error.destroy() end

        if p.connected == false and not sensor_settings.show_offline then
            if gui_list[player_name] and gui_list[player_name].valid then
                gui_list[player_name].destroy()
            end
            goto next_player
        end

        if gui_list[player_name] == nil then
            gui_list.add{type="label", name=player_name}
        end

        local direction = '?'
        local current_player = game.get_player(owner.player_index)
        if p == current_player then
            direction = ''
        elseif current_player then
            direction = directions(current_player, p)
        end

        local desc = {''}
        if sensor_settings.show_player_index then
            table.insert(desc, string.format('(%d) ', p.index))
        end

        if player_name == "sensor.player_locations.local_player" then
            table.insert(desc, {player_name})
        else
            table.insert(desc, player_name)
        end

        if p.connected == false then
            table.insert(desc, ' ')
            table.insert(desc, {"sensor.player_locations.offline_fragment"})
        end

        if sensor_settings.show_position or sensor_settings.show_surface then
            table.insert(desc, ' (')
            if sensor_settings.show_position then
                table.insert(desc, string.format('@%d, %d', p.position.x, p.position.y))
            end
            if sensor_settings.show_surface then
                if sensor_settings.show_position then
                    table.insert(desc, ' ')
                end
                table.insert(desc, {"sensor.player_locations.surface_fragment", p.surface.name})
            end
            table.insert(desc, ')')
        end

        if sensor_settings.show_direction then
            table.insert(desc, ' ')
            table.insert(desc, direction)
        end

        gui_list[player_name].caption = desc
        ::next_player::
    end
end

ValueSensor.register(sensor)
