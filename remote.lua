if not evogui then evogui = { log = function() end } end


local function get_player_by_name(player_name)
    for _, p in pairs(game.players) do
        if p.name == player_name then
            return p
        end
    end
    return nil
end


local function remote_rebuild(player_name)
    if not player_name then
        evogui.log({"err_needplayername"})
        return
    end

    player = get_player_by_name(player_name)
    if not player then
        evogui.log({"err_nosuchplayer", tostring(player_name)})
        return
    end

    if not global.evogui or not global.evogui[player_name] then
        evogui.log({"err_noplayerdata", player_name})
        return
    end

    global.evogui[player.name].version = ""
end

--
-- Creates a sensor managed by a remote interface (another mod or script)
-- sensor_data: a table with the following fields,
--     mod_name: Name of the mod registering the sensor. Sensor will be removed
--         if the mod is removed from the game.
--     name: Internal name of the sensor. Should be unique (otherwise you're
--         just redefining the existing one).
--     text: Text to display in the active gui (may be localized).
--     caption: Sensor setting name in the EvoGUI settings panel (may be localized).
--     color: Font color of the text to display in the active gui, optional, may be nil.
--
-- example: remote.call("EvoGUI", "create_remote_sensor", { mod_name = "my_mod",
--                                                          name = "my_mod_my_sensor_name",
--                                                          text = "Text: Lorem Ipsum",
--                                                          caption = "Lorem Ipsum Text" })
-- or, with locale:
-- remote.call("EvoGUI", "create_remote_sensor", { mod_name = "my_mod",
--                                                 name = "my_mod_my_sensor_name",
--                                                 text = {"my_mod_sensor_display", 42},
--                                                 caption = {"my_mod_sensor"} })
local function create_remote_sensor(sensor_data)
    if not sensor_data then
        evogui.log({"err_no_sensor_data"})
        return
    end

    for _, field in pairs({ "mod_name", "name", "text", "caption" }) do
        if not sensor_data[field] then
            evogui.log({"err_sensor_missing_field", serpent.dump(sensor_data, {compact = false, nocode = true, indent = ' '}), field})
            return
        end
    end

    local sensor = RemoteSensor.get_by_name(sensor_data.name)
    if not sensor then
        RemoteSensor.new(sensor_data)
    end
end

--
-- Updates a sensor managed by a remote interface
-- sensor_name: internal name of the sensor. The sensor should have been previously created.
-- sensor_text: Text to display in the active gui
-- sensor_color: Font color of the text to display in the active gui, optional, may be nil
-- example: remote.call("EvoGUI", "update_remote_sensor", "mymod_my_sensor_name", "Text: Lorem Ipsum")
local function update_remote_sensor(sensor_name, sensor_text, sensor_color)
    if not sensor_name then
        evogui.log({"err_nosensorname"})
        return
    end

    if not sensor_text then
        evogui.log({"err_nosensortext", sensor_name})
        return
    end

    local sensor = RemoteSensor.get_by_name(sensor_name)
    if not sensor then
        evogui.log({"err_nosensorfound", sensor_name})
        return
    end

    sensor["line"] = sensor_text
    if sensor_color then
        sensor["color"] = sensor_color
    end
end

--
-- Checks if a remote sensor exists, returns true if one was does
-- sensor_name: internal name of the sensor.
-- example: remote.call("EvoGUI", "does_remote_sensor_exist", "mymod_my_sensor_name")
local function does_remote_sensor_exist(sensor_name)
    if not sensor_name then
        evogui.log({"err_nosensorname"})
        return
    end
    local sensor = RemoteSensor.get_by_name(sensor_name)
    return sensor ~= nil
end

--
-- Removes a sensor managed by a remote interface, returns true if one was removed
-- sensor_name: internal name of the sensor. The sensor should have been previously created.
-- example: remote.call("EvoGUI", "remove_remote_sensor", "mymod_my_sensor_name")
local function remove_remote_sensor(sensor_name)
    if not sensor_name then
        evogui.log({"err_nosensorname"})
        return
    end
    local sensor = RemoteSensor.get_by_name(sensor_name)
    if not sensor then
        -- impossible to know if the sensor was removed in advance, so just return a status
        return false
    end
    evogui.hide_sensor(sensor)
    for idx, sensor in pairs(evogui.value_sensors) do
        if sensor.name == ("remote_sensor_" .. sensor_name) then
            table.remove(evogui.value_sensors, idx)
        end
    end
    global.remote_sensors[sensor_name] = nil
    return true
end

interface = {
    rebuild = function(player_name)
        local status, err = pcall(remote_rebuild, player_name)
        if err then evogui.log({"err_generic", "interface.rebuild", err}) end
    end,

    create_remote_sensor = function(sensor_data)
        local status, err = pcall(create_remote_sensor, sensor_data)
        if err then evogui.log({"err_generic", "remote.create_remote_sensor", err}) end
    end,

    update_remote_sensor = function(sensor_name, sensor_text, sensor_color)
        local status, err = pcall(update_remote_sensor, sensor_name, sensor_text, sensor_color)
        if err then evogui.log({"err_generic", "remote.update_remote_sensor", err}) end
    end,

    does_remote_sensor_exist = function(sensor_name)
        local status, err = pcall(does_remote_sensor_exist, sensor_name)
        -- properly pass the return value
        if status then return err
        elseif err then evogui.log({"err_generic", "remote.remove_remote_sensor", err}) end
    end,

    remove_remote_sensor = function(sensor_name)
        local status, err = pcall(remove_remote_sensor, sensor_name)
        -- properly pass the return value
        if status then return err
        elseif err then evogui.log({"err_generic", "remote.remove_remote_sensor", err}) end
    end
}


remote.add_interface("EvoGUI", interface)
