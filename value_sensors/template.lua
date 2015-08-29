
ValueSensor = {}

if not evogui then evogui = {} end
if not evogui.value_sensors then evogui.value_sensors = {} end

function ValueSensor.new(name)
    local sensor = {
        ["name"] = name,
        ["display_name"] = { "sensor."..name..".name" },
        ["format_key"] = "sensor."..name..".format",
    }

    function sensor:get_line()
        return self.display_name
    end

    function sensor:create_ui(owner)
        if owner[self.name] == nil then
            owner.add{type="label", name=self.name}
        end
    end

    function sensor:update_ui(owner)
        owner[self.name].caption = self:get_line()
    end

    function sensor:delete_ui(owner)
        if owner[self.name] ~= nil then
            owner[self.name].destroy()
        end
    end

    function sensor:settings_root_name()
        return self.name.."_settings"
    end

    return sensor
end

function ValueSensor.register(sensor)
    table.insert(evogui.value_sensors, sensor)
end

function ValueSensor.get_by_name(sensor_name)
    for _, sensor in pairs(evogui.value_sensors) do
        if sensor.name == sensor_name then
            return sensor
        end
    end
    return nil
end

return ValueSensor
