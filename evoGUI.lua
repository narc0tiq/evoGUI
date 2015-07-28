require "defines"

if not evogui then evogui = {} end
evogui.update_delay = 60 -- ticks to wait between each GUI update

local function update_gui()
    if (game.tick % evogui.update_delay) == 0 then
        for i, player in ipairs(game.players) do
            evogui.create_or_update(player)

            if player.gui.top.evoGUI then
                evogui.update_evolution(player.gui.top.evoGUI.evolution_factor)
                evogui.update_run_time(player.gui.top.evoGUI.run_time)
                evogui.update_day_time(player.gui.top.evoGUI.first_line.day_time)
            end
        end
    end
end
evogui.update_gui = update_gui

local function create_or_update(player)
    if not player.gui.top.evoGUI  then
        player.gui.top.add{type="frame", name="evoGUI", direction = "vertical"}
        player.gui.top.evoGUI.add{type="frame", name="first_line", direction = "horizontal", style="naked_frame_style"}
        player.gui.top.evoGUI.first_line.add{type="button", name="evoGUI_size", caption="-", style="evoGUI_small_button_style"}
        player.gui.top.evoGUI.first_line.add{type="label", name="day_time"}
        player.gui.top.evoGUI.add{type="label", name="evolution_factor"}
        player.gui.top.evoGUI.add{type="label", name="run_time"}
    end

    if not player.gui.top.evoGUI.first_line or
        not player.gui.top.evoGUI.first_line.evoGUI_size or
        not player.gui.top.evoGUI.first_line.day_time or
        not player.gui.top.evoGUI.evolution_factor or
        not player.gui.top.evoGUI.run_time then
        player.gui.top.evoGUI.destroy()
    end
end
evogui.create_or_update = create_or_update

local function update_evolution(element)
    element.caption = {"biter-evolution", string.format("%0.1f%%", game.evolution_factor * 100)}
end
evogui.update_evolution = update_evolution

local function update_run_time(element)
    local run_time_seconds = math.floor(game.tick/60)
    local run_time_minutes = math.floor(run_time_seconds/60)
    local run_time_hours = math.floor(run_time_minutes/60)

    element.caption = {"play-time", string.format("%d:%02d:%02d",
                                                          run_time_hours,
                                                          run_time_minutes % 60,
                                                          run_time_seconds % 60)}
end
evogui.update_run_time = update_run_time

local function update_day_time(element)
    -- 0.5 is midnight; let's make days *start* at midnight instead.
    local day_time = math.fmod(game.daytime + 0.5, 1)

    local day_time_minutes = math.floor(day_time * 24 * 60)
    local day_time_hours = math.floor(day_time_minutes / 60)

    local rounded_minutes = day_time_minutes - (day_time_minutes % 15)

    local brightness = math.floor((1 - game.darkness) * 100)

    element.caption = {"", {"time-of-day", string.format("%d:%02d", day_time_hours, rounded_minutes % 60)}, " ",
                                   {"brightness", string.format("%d%%", brightness)}}
end
evogui.update_day_time = update_day_time
