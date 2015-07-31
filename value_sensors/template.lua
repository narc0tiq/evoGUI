
ValueSensor = {}

if not evogui then evogui = {} end
if not evogui.value_sensors then evogui.value_sensors = {} end

function ValueSensor.new(name, get_line)
    local sensor = {
        ["name"] = name,
        ["display_name"] = { "sensor."..name..".name" },
        ["format_key"] = "sensor."..name..".format",
        ["get_line"] = get_line,
    }
    evogui.value_sensors[name] = sensor
    return sensor
end

return ValueSensor
