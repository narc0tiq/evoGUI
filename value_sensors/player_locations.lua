require "template"

if not evogui.on_click then evogui.on_click = {} end
local sensor = ValueSensor.new("player_locations")


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
    root.add{type="checkbox", name="evogui_show_player_index",
             caption={"sensor.player_locations.settings.show_player_index"},
             state=sensor_settings.show_player_index}
    evogui.on_click.evogui_show_player_index = self:make_on_click_checkbox_handler("show_player_index")

    root.add{type="checkbox", name="evogui_show_position",
             caption={"sensor.player_locations.settings.show_position"},
             state=sensor_settings.show_position}
    evogui.on_click.evogui_show_position = self:make_on_click_checkbox_handler("show_position")

    root.add{type="checkbox", name="evogui_show_surface",
             caption={"sensor.player_locations.settings.show_surface"},
             state=sensor_settings.show_surface}
    evogui.on_click.evogui_show_surface = self:make_on_click_checkbox_handler("show_surface")

    root.add{type="checkbox", name="evogui_show_direction",
             caption={"sensor.player_locations.settings.show_direction"},
             state=sensor_settings.show_direction}
    evogui.on_click.evogui_show_direction = self:make_on_click_checkbox_handler("show_direction")

    root.add{type="checkbox", name="evogui_show_offline",
             caption={"sensor.player_locations.settings.show_offline"},
             state=sensor_settings.show_offline}
    evogui.on_click.evogui_show_offline = self:make_on_click_checkbox_handler("show_offline")

    local btn_close = root.add{type="button", name="evogui_custom_sensor_close", caption={"settings_close"}}
    evogui.on_click[btn_close.name] = function(event) self:close_settings_gui(player_index) end
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
        if not p.name or p.name == '' then
            if gui_list.error == nil then
                gui_list.add{type="label", name="error", caption={"sensor.player_locations.err_no_name"}}
            end
            break
        end

        if gui_list.error ~= nil then gui_list.error.destroy() end

        if p.connected == false and not sensor_settings.show_offline then
            if gui_list[p.name] and gui_list[p.name].valid then
                gui_list[p.name].destroy()
            end
            goto next_player
        end

        if gui_list[p.name] == nil then
            gui_list.add{type="label", name=p.name}
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

        table.insert(desc, p.name)

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

        gui_list[p.name].caption = desc
        ::next_player::
    end
end

ValueSensor.register(sensor)
