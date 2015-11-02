require "template"

RemoteSensor = {}
function RemoteSensor.new(name, line, caption, color)
    local sensor = ValueSensor.new("remote_sensor_" .. name)
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
end

function RemoteSensor.get_by_name(name)
    return ValueSensor.get_by_name("remote_sensor_" .. name)
end

return RemoteSensor
