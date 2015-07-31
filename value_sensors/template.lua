
ValueSensor = {}

function ValueSensor.new(name, get_line)
    return {
        ["name"] = name,
        ["display_name"] = { "sensor."..name..".name" },
        ["format_key"] = "sensor."..name..".format",
        ["get_line"] = get_line,
    }
end

return ValueSensor
