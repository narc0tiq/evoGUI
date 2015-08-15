require "template"

local sensor = ValueSensor.new("evolution_factor")

function sensor:get_line()
    return {self.format_key, string.format("%0.1f%%", game.evolution_factor * 100)}
end

ValueSensor.register(sensor)
