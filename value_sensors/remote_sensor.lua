require "template"

RemoteSensor = {}
function RemoteSensor.new(mod_name, name, line, caption, color)
    local sensor = ValueSensor.new("remote_sensor_" .. name)

    sensor["mod_name"] = mod_name
    sensor["line"] = line
    sensor["display_name"] = caption
    sensor["color"] = color

    function sensor:set_line(text)
        self.line = text
    end

    function sensor:get_line()
        return self.line
    end

    ValueSensor.register(sensor)
    if not global.remote_sensors then
        global.remote_sensors = {}
    end
    
    -- store sensor data for global serialization
    local sensor_data = {
        mod_name = sensor.mod_name,
        name = name,
        line = sensor.line,
        display_name = sensor.display_name,
        color = sensor.color
     }
    global.remote_sensors[name] = sensor_data
end

function RemoteSensor.get_by_name(name)
    return ValueSensor.get_by_name("remote_sensor_" .. name)
end

function RemoteSensor.initialize()
     -- Initialize any remote sensors that were previously saved
    if global.remote_sensors then
        print("Global Remote Sensors: " .. serpent.dump(global.remote_sensors))
        for _, sensor in pairs(global.remote_sensors) do
            if not RemoteSensor.get_by_name(sensor.name) then
                RemoteSensor.new(sensor.mod_name, sensor.name, sensor.line, sensor.display_name, sensor.color)
            end
        end
    end
end

return RemoteSensor
