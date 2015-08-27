require "defines"
require "evoGUI"

if not evogui then evogui = {} end

function evogui.log(message)
    for i, p in ipairs(game.players) do
        p.print(message)
    end
end

game.on_event(defines.events.on_tick, function(event)
    local status, err = pcall(evogui.update_gui)
    if err then evogui.log({"err_generic", "on_tick", err}) end
end)

game.on_event(defines.events.on_gui_click, function(event)
    if evogui.on_click[event.element.name] ~= nil then
        local status, err = pcall(evogui.on_click[event.element.name], event)
        if err then
            if event.element.valid then
                evogui.log({"err_specific", "on_gui_click", event.element.name, err})
            else
                evogui.log({"err_generic", "on_gui_click", err})
            end
        end
    end
end)
