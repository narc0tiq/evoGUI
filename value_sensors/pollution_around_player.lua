require "template"

PollutionSensor = {}

function PollutionSensor.new(player)
    local sensor = ValueSensor.new("pollution_around_player")

    sensor.player = player

    function sensor:get_line()
        local surface = self.player.surface
        local pollution = surface.get_pollution(self.player.position)

        return {self.format_key, string.format("%0.1f", pollution)}
    end

    return sensor
end



