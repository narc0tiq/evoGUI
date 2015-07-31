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
    if evogui.on_click[event.element.name] ~= nil then
        local status, err = pcall(evogui.on_click[event.element.name], event)
        if err then log(string.format("[evoGUI|on_gui_click|%s] Error: %s", event.element.name, err)) end
    end
end)
