
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

    return sensor
end

function ValueSensor.register(sensor)
    table.insert(evogui.value_sensors, sensor)
end

return ValueSensor
