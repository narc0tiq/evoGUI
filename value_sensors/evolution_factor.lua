require "template"

local sensor = ValueSensor.new("evolution_factor", function(self)
    return {self.format_key, string.format("%0.1f%%", game.evolution_factor * 100)}
end)

if not evogui then evogui = {} end

function evogui.update_evolution(element)
    element.caption = sensor:get_line()
end
