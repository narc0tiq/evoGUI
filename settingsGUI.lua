require "defines"

if not evogui then evogui = {} end
if not evogui.on_click then evogui.on_click = {} end

if not global.evogui then global.evogui = {} end


local function toggle_always_visible(event)
    local player = game.get_player(event.player_index)

    if event.element.name:sub(1,3) ~= "AV_" then
        error(string.format("toggle_always_visible called on the wrong thing: %s", event.element.name))
        return
    end

    local always_visible = global.evogui[player.name].always_visible
    local sensor_name = event.element.name:sub(4,-1)
    if event.element.state then
        always_visible[sensor_name] = true
    else
        always_visible[sensor_name] = nil
    end
end


local function toggle_in_popup(event)
    local player = game.get_player(event.player_index)

    if event.element.name:sub(1,3) ~= "IP_" then
        error(string.format("toggle_in_popup called on the wrong thing: %s", event.element.name))
        return
    end

    local in_popup = global.evogui[player.name].in_popup
    local sensor_name = event.element.name:sub(4,-1)
    if event.element.state then
        in_popup[sensor_name] = true
    else
        in_popup[sensor_name] = nil
    end
end


local function add_sensor_table_row(table, sensor, always_visible, in_popup)
    local sensor_always_visible = always_visible[sensor.name] ~= nil
    local sensor_in_popup = in_popup[sensor.name] ~= nil

    table.add{type="label", caption=sensor.display_name}
    table.add{type="checkbox", name="AV_"..sensor.name,
        caption={"settings_always_visible"}, state=sensor_always_visible}
    table.add{type="checkbox", name="IP_"..sensor.name,
        caption={"settings_in_popup"}, state=sensor_in_popup}

    evogui.on_click["AV_"..sensor.name] = toggle_always_visible
    evogui.on_click["IP_"..sensor.name] = toggle_in_popup
end


function evogui.on_click.evoGUI_settings(event)
    local player = game.get_player(event.player_index)
    if player.gui.center.evoGUI_settingsGUI then return end

    evogui.create_player_globals(player)
    local player_data = global.evogui[player.name]

    local root = player.gui.center.add{type="frame",
                                       direction="vertical",
                                       name="evoGUI_settingsGUI",
                                       caption={"settings_title"}}
    local table = root.add{type="table", colspan=3}

    for _, sensor in ipairs(evogui.value_sensors) do
        add_sensor_table_row(table, sensor, player_data.always_visible, player_data.in_popup)
    end

    for _, sensor in ipairs(player_data.personal_sensors) do
        add_sensor_table_row(table, sensor, player_data.always_visible, player_data.in_popup)
    end

    local buttons = root.add{type="flow", direction="horizontal"}
    buttons.add{type="button", name="evoGUI_settings_close", caption={"settings_close"}}
end

function evogui.on_click.evoGUI_settings_close(event)
    local player = game.get_player(event.player_index)

    if player.gui.center.evoGUI_settingsGUI ~= nil then
        player.gui.center.evoGUI_settingsGUI.destroy()
    end
end
