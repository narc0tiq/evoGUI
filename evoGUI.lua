require "defines"
require "value_sensors.day_time"
require "value_sensors.evolution_factor"
require "value_sensors.play_time"

if not evogui then evogui = {} end
if not evogui.on_click then evogui.on_click = {} end

evogui.update_delay = 60 -- ticks to wait between each GUI update

function evogui.update_gui()
    if (game.tick % evogui.update_delay) == 0 then
        for i, player in ipairs(game.players) do
            evogui.create_or_update(player)

            if not player.gui.top.evoGUI then
                return
            end

            if player.gui.top.evoGUI.evolution_factor then
                evogui.update_evolution(player.gui.top.evoGUI.evolution_factor)
            end
            if player.gui.top.evoGUI.play_time then
                evogui.update_play_time(player.gui.top.evoGUI.play_time)
            end
            if player.gui.top.evoGUI.first_line.day_time then
                evogui.update_day_time(player.gui.top.evoGUI.first_line.day_time)
            end
        end
    end
end

function evogui.create_or_update(player)
    if not player.gui.top.evoGUI  then
        player.gui.top.add{type="frame", name="evoGUI", direction = "vertical"}
        player.gui.top.evoGUI.add{type="frame", name="first_line", direction = "horizontal", style="naked_frame_style"}
        player.gui.top.evoGUI.first_line.add{type="button", name="evoGUI_size", caption="-", style="evoGUI_small_button_style"}
        player.gui.top.evoGUI.first_line.add{type="label", name="day_time"}
        player.gui.top.evoGUI.add{type="label", name="evolution_factor"}
        player.gui.top.evoGUI.add{type="label", name="play_time"}
    end

    if not player.gui.top.evoGUI.first_line or
        not player.gui.top.evoGUI.first_line.evoGUI_size or
        not player.gui.top.evoGUI.first_line.day_time then
        player.gui.top.evoGUI.destroy()
    end
end

function evogui.on_click.evoGUI_size(event)
    local player = game.get_player(event.player_index)

    if player.gui.top.evoGUI.evolution_factor ~= nil then
        -- hide the extra bits
        player.gui.top.evoGUI.evolution_factor.destroy()
        player.gui.top.evoGUI.play_time.destroy()
        player.gui.top.evoGUI.first_line.evoGUI_size.caption = "+"
    else
        -- show the extra bits
        player.gui.top.evoGUI.add{type="label", name="evolution_factor"}
        evogui.update_evolution(player.gui.top.evoGUI.evolution_factor)

        player.gui.top.evoGUI.add{type="label", name="play_time"}
        evogui.update_play_time(player.gui.top.evoGUI.play_time)

        player.gui.top.evoGUI.first_line.evoGUI_size.caption = "-"
    end
end
