require "defines"

if not evogui then evogui = {} end
evogui.previous = -1

local function update_gui()
    local run_time_seconds = math.floor(game.tick/60)
    local run_time_minutes = math.floor(run_time_seconds/60)
    local run_time_hours = math.floor(run_time_minutes/60)

    if evogui.previous ~= run_time_seconds then
        for i, player in ipairs(game.players) do
            if player.gui.top.evoGUI == nil then
                player.gui.top.add{type="frame", name="evoGUI", direction = "vertical"}
                player.gui.top.evoGUI.add{type="label", name="evolution_factor"}
                player.gui.top.evoGUI.add{type="label", name="run_time"}
            end
            player.gui.top.evoGUI.evolution_factor.caption = string.format("Biter evolution: %0.1f%%", game.evolution_factor * 100)
            player.gui.top.evoGUI.run_time.caption = string.format("Play time: %d:%02d:%02d",
                                                                   run_time_hours,
                                                                   run_time_minutes % 60,
                                                                   run_time_seconds % 60)
        end
        evogui.previous = run_time_seconds
    end
end

evogui.update_gui = update_gui
