require "template"

local sensor = ValueSensor.new("day_time")

function sensor:get_line()
    -- 0.5 is midnight; let's make days *start* at midnight instead.
    local day_time = math.fmod(game.daytime + 0.5, 1)

    local day_time_minutes = math.floor(day_time * 24 * 60)
    local day_time_hours = math.floor(day_time_minutes / 60)

    local rounded_minutes = day_time_minutes - (day_time_minutes % 15)

    local brightness = math.floor((1 - game.darkness) * 100)

    return {self.format_key,
            string.format("%d:%02d", day_time_hours, rounded_minutes % 60),
            string.format("%d%%", brightness)}
end
