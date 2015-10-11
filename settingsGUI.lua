require "defines"

if not evogui then evogui = {} end
if not evogui.on_click then evogui.on_click = {} end

if not global.evogui then global.evogui = {} end
if not global.settings then global.settings = {} end


local function toggle_always_visible(event)
    local player = game.get_player(event.player_index)

    if event.element.name:sub(1,3) ~= "AV_" then
        error({"err_settings_badcall", "toggle_always_visible"})
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
        error({"err_settings_badcall", "toggle_in_popup"})
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


local function on_sensor_settings_closed(player_index)
    evogui.on_click.evoGUI_settings({player_index = player_index})
end


local function trigger_settings_gui(event)
    local player = game.get_player(event.player_index)

    if event.element.name:sub(1,11) ~= "EvoGUI_SET_" then
        error({"err_settings_badcall", "trigger_settings_gui"})
        return
    end

    local sensor_name = event.element.name:sub(12,-1)
    local sensor = ValueSensor.get_by_name(sensor_name)
    if sensor == nil then
        error({"err_settings_whatsensor", "trigger_settings_gui"})
        return
    end

    if sensor.settings_gui == nil then
        error({"err_settings_whatsettings", "trigger_settings_gui"})
        return
    end

    if player.gui.center.evoGUI_settingsGUI ~= nil then
        player.gui.center.evoGUI_settingsGUI.destroy()
    end

    sensor.settings_gui_closed = on_sensor_settings_closed
    sensor:settings_gui(event.player_index)
end


local function add_sensor_table_row(table, sensor, always_visible, in_popup)
    local sensor_always_visible = always_visible[sensor.name] ~= nil
    local sensor_in_popup = in_popup[sensor.name] ~= nil

    table.add{type="label", caption=sensor.display_name}
    table.add{type="checkbox", name="AV_"..sensor.name,
        caption={"settings_always_visible"}, state=sensor_always_visible}
    table.add{type="checkbox", name="IP_"..sensor.name,
        caption={"settings_in_popup"}, state=sensor_in_popup}
    if sensor.settings_gui ~= nil then
        local button_name = "EvoGUI_SET_"..sensor.name
        table.add{type="button", name=button_name,
            style="EvoGUI_settings"}
        evogui.on_click[button_name] = trigger_settings_gui
    else
        table.add{type="flow"} -- empty, but there has to be _something_ there.
    end

    evogui.on_click["AV_"..sensor.name] = toggle_always_visible
    evogui.on_click["IP_"..sensor.name] = toggle_in_popup
end


function evogui.on_click.evoGUI_settings(event)
    local player = game.get_player(event.player_index)
    if player.gui.center.evoGUI_settingsGUI ~= nil then
        player.gui.center.evoGUI_settingsGUI.destroy()
        return
    end

    evogui.create_player_globals(player)
    local player_data = global.evogui[player.name]

    local root = player.gui.center.add{type="frame",
                                       direction="vertical",
                                       name="evoGUI_settingsGUI",
                                       caption={"settings_title"}}

    local core_settings = root.add{type="frame",
                                   name="core_settings",
                                   caption={"settings.core_settings.title"},
                                   direction="vertical",
                                   style="naked_frame_style"}

    local update_freq_flow = core_settings.add{type="flow", name="update_freq_flow", direction="horizontal"}
    update_freq_flow.add{type="label", caption={"settings.core_settings.update_freq_left"}}
    local textfield = update_freq_flow.add{type="textfield", name="textfield", style="number_textfield_style"}
    textfield.text=tostring(global.settings.update_delay)
    update_freq_flow.add{type="label", caption={"settings.core_settings.update_freq_right"}}

    local sensors_frame = root.add{type="frame",
                                   name="sensors_frame",
                                   caption={"settings.sensors_frame.title"},
                                   direction="vertical",
                                   style="naked_frame_style"}

    local table = sensors_frame.add{type="table", name="table", colspan=4}

    for _, sensor in ipairs(evogui.value_sensors) do
        add_sensor_table_row(table, sensor, player_data.always_visible, player_data.in_popup)
    end

    for _, sensor in ipairs(player_data.personal_sensors) do
        add_sensor_table_row(table, sensor, player_data.always_visible, player_data.in_popup)
    end

    local buttons = root.add{type="flow", name="buttons", direction="horizontal"}
    buttons.add{type="button", name="evoGUI_settings_close", caption={"settings_close"}}
end


function evogui.on_click.evoGUI_settings_close(event)
    local player = game.get_player(event.player_index)

    local new_update_freq = tonumber(player.gui.center.evoGUI_settingsGUI.core_settings.update_freq_flow.textfield.text)
    if new_update_freq ~= nil then
        global.settings.update_delay = new_update_freq
    end

    if player.gui.center.evoGUI_settingsGUI ~= nil then
        player.gui.center.evoGUI_settingsGUI.destroy()
    end
end
