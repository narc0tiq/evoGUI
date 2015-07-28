require "defines"
require "evoGUI"

local function log(message)
    for i, p in ipairs(game.players) do
        p.print(message)
    end
end

game.on_event(defines.events.on_tick, function(event)
    local status, err = pcall(evogui.update_gui)
    if err then log(string.format("[evoGUI] Error: %s", err)) end
end)

game.on_event(defines.events.on_gui_click, function(event)
    log(string.format("Player %d (%s) pressed the %s thingy", event.player_index, game.get_player(event.player_index).name, event.element.name))
end)
