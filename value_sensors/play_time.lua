require "template"

local sensor = ValueSensor.new("play_time", function(self)
    local play_time_seconds = math.floor(game.tick/60)
    local play_time_minutes = math.floor(play_time_seconds/60)
    local play_time_hours = math.floor(play_time_minutes/60)

    return {self.format_key,
            string.format("%d:%02d:%02d", play_time_hours, play_time_minutes % 60, play_time_seconds % 60)}
end)

function evogui.update_play_time(element)
    element.caption = sensor:get_line()
end
