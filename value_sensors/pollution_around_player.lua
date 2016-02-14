require "template"

PollutionSensor = {}

function PollutionSensor.new(player)
    local sensor = ValueSensor.new("pollution_around_player")

    sensor.player = player

    function sensor:get_line()
        local surface = self.player.surface
        local pollution = surface.get_pollution(self.player.position)
        
        -- this nonsense is because string.format(%.1f) is not safe in MP across platforms, but integer math is
        local whole_number = math.floor(pollution)
        local fractional_component = math.floor((pollution - whole_number) * 10)
        
        return {self.format_key, (whole_number .. "." .. fractional_component)}
    end

    return sensor
end
