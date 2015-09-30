require "defines"
require "value_sensors.day_time"
require "value_sensors.evolution_factor"
require "value_sensors.kill_count"
require "value_sensors.play_time"
require "value_sensors.player_locations"
require "value_sensors.pollution_around_player"
require "settingsGUI"
require "remote"

if not evogui then evogui = {} end
if not evogui.on_click then evogui.on_click = {} end

local EXPECTED_VERSION = "{{VERSION}}"


function evogui.update_gui()
    if not global.settings then global.settings = {} end
    if not global.settings.update_delay then global.settings.update_delay = 60 end

    if (game.tick % global.settings.update_delay) == 0 then
        for i, player in ipairs(game.players) do
            evogui.create_player_globals(player)
            evogui.create_sensor_display(player)

            local player_settings = global.evogui[player.name]

            local sensor_flow = player.gui.top.evoGUI.sensor_flow
            evogui.update_av(player, sensor_flow.always_visible)
            if player_settings.popup_open then
                evogui.update_ip(player, sensor_flow.in_popup)
            end
        end
    end
end


function evogui.create_player_globals(player)
    if not global.evogui then global.evogui = {} end
    if not global.evogui[player.name] then global.evogui[player.name] = {} end
    local player_settings = global.evogui[player.name]

    if not player_settings.version then player_settings.version = "" end

    if not player_settings.always_visible then
        player_settings.always_visible = {
            ["evolution_factor"] = true,
            ["play_time"] = true,
        }
    end

    if not player_settings.in_popup then
        player_settings.in_popup = {
            ["day_time"] = true,
        }
    end

    if not player_settings.popup_open then player_settings.popup_open = false end

    if not player_settings.personal_sensors then
        player_settings.personal_sensors = {}

        table.insert(player_settings.personal_sensors, PollutionSensor.new(player))
    end

    if not player_settings.sensor_settings then
        player_settings.sensor_settings = {}
    end

    if not player_settings.sensor_settings['player_locations'] then
        player_settings.sensor_settings['player_locations'] = {
            ['show_player_index'] = false,
            ['show_position'] = false,
            ['show_surface'] = false,
            ['show_direction'] = true,
        }
    end

    if not player_settings.sensor_settings['day_time'] then
        player_settings.sensor_settings['day_time'] = {
            ['show_day_number'] = false,
            ['minute_rounding'] = true,
        }
    end

    if not player_settings.sensor_settings['evolution_factor'] then
        player_settings.sensor_settings['evolution_factor'] = {
            ['extra_precision'] = false,
        }
    end

    if not player_settings.sensor_settings['play_time'] then
        player_settings.sensor_settings['play_time'] = {
            ['show_days'] = true,
            ['show_seconds'] = true,
        }
    end
end


function evogui.create_sensor_display(player)
    local root = player.gui.top.evoGUI
    local destroyed = false
    if root and global.evogui[player.name].version ~= EXPECTED_VERSION then
        player.gui.top.evoGUI.destroy()
        destroyed = true
    end

    if not root or destroyed then
        local root = player.gui.top.add{type="frame",
                                        name="evoGUI",
                                        direction="horizontal",
                                        style="outer_frame_style"}

        local action_buttons = root.add{type="flow",
                                        name="action_buttons",
                                        direction="vertical",
                                        style="description_flow_style"}
        action_buttons.add{type="button",
                           name="evoGUI_toggle_popup",
                           style="EvoGUI_expando_closed"}
        if global.evogui[player.name].popup_open then
            action_buttons.evoGUI_toggle_popup.style = "EvoGUI_expando_open"
        end
        action_buttons.add{type="button",
                           name="evoGUI_settings",
                           style="EvoGUI_settings"}

        local sensor_flow = root.add{type="flow",
                                     name="sensor_flow",
                                     direction="vertical",
                                     style="description_flow_style"}
        sensor_flow.add{type="flow",
                        name="always_visible",
                        direction="vertical",
                        style="description_flow_style"}
        sensor_flow.add{type="flow",
                        name="in_popup",
                        direction="vertical",
                        style="description_flow_style"}

        global.evogui[player.name].version = EXPECTED_VERSION
    end
end


local function update_sensors(element, sensor_list, active_sensors)
    for _, sensor in ipairs(sensor_list) do
        if active_sensors[sensor.name] then
            sensor:create_ui(element)
            sensor:update_ui(element)
        else
            sensor:delete_ui(element)
        end
    end
end


function evogui.update_av(player, element)
    local always_visible = global.evogui[player.name].always_visible

    update_sensors(element, evogui.value_sensors, always_visible)
    update_sensors(element, global.evogui[player.name].personal_sensors, always_visible)
end


function evogui.update_ip(player, element)
    if not global.evogui[player.name].popup_open then return end

    local in_popup = global.evogui[player.name].in_popup

    update_sensors(element, evogui.value_sensors, in_popup)
    update_sensors(element, global.evogui[player.name].personal_sensors, in_popup)
end


function evogui.on_click.evoGUI_toggle_popup(event)
    local player = game.get_player(event.player_index)
    local player_settings = global.evogui[player.name]

    local root = player.gui.top.evoGUI

    if player_settings.popup_open then
        -- close it
        player_settings.popup_open = false

        for _, childname in ipairs(root.sensor_flow.in_popup.children_names) do
            root.sensor_flow.in_popup[childname].destroy()
        end

        root.action_buttons.evoGUI_toggle_popup.style = "EvoGUI_expando_closed"
    else
        -- open it
        player_settings.popup_open = true

        evogui.update_ip(player, root.sensor_flow.in_popup)
        root.action_buttons.evoGUI_toggle_popup.style = "EvoGUI_expando_open"
    end
end
