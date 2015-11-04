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
-- mod_name: Name of the mod registering the sensor. Sensor will be removed if the mod is removed from the game.
-- sensor_name: internal name of the sensor. Should be unique.
-- sensor_text: Text to display in the active gui
-- sensor_caption: Sensor setting name in the EvoGUI settings panel
-- sensor_color: Font color of the text to display in the active gui, optional, may be nil
-- example: remote.call("EvoGUI", "create_remote_sensor", "mymod_my_sensor_name", "Text: Lorem Ipsum", "[My Mod] Lorem Ipsum Text")
local function create_remote_sensor(mod_name, sensor_name, sensor_text, sensor_caption, sensor_color)
    if not mod_name then
        evogui.log({"err_nomodname"})
        return
    end

    if not sensor_name then
        evogui.log({"err_nosensorname"})
        return
    end

    if not sensor_text then
        evogui.log({"err_nosensortext", sensor_name})
        return
    end

    if not sensor_caption then
        evogui.log({"err_nosensorcaption", sensor_name})
        return
    end
    
    local sensor = RemoteSensor.get_by_name(sensor_name)
    if not sensor then
        RemoteSensor.new(mod_name, sensor_name, sensor_text, sensor_caption, sensor_color)
    else
        -- should anything happen here?
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


interface = {
    rebuild = function(player_name)
        local status, err = pcall(remote_rebuild, player_name)
        if err then evogui.log({"err_generic", "interface.rebuild", err}) end
    end,

    create_remote_sensor = function(mod_name, sensor_name, sensor_text, sensor_caption, sensor_color)
        local status, err = pcall(create_remote_sensor, mod_name, sensor_name, sensor_text, sensor_caption, sensor_color)
        if err then evogui.log({"err_generic", "remote.create_remote_sensor", err}) end
    end,

    update_remote_sensor = function(sensor_name, sensor_text, sensor_color)
        local status, err = pcall(update_remote_sensor, sensor_name, sensor_text, sensor_color)
        if err then evogui.log({"err_generic", "remote.update_remote_sensor", err}) end
    end
}


remote.add_interface("EvoGUI", interface)
