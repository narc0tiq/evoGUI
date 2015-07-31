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

            if not player.gui.top.evoGUI then return end

            local sensors = player.gui.top.evoGUI.sensors
            if not sensors then return end

            if sensors.evolution_factor then
                evogui.update_evolution(sensors.evolution_factor)
            end
            if sensors.play_time then
                evogui.update_play_time(sensors.play_time)
            end
            if sensors.day_time then
                evogui.update_day_time(sensors.day_time)
            end
        end
    end
end

function evogui.create_or_update(player)
    local root = player.gui.top.evoGUI
    local destroyed = false
    if root and (not global.evoGUI or not global.evoGUI.version or global.evoGUI.version ~= "0.3.0") then
        player.gui.top.evoGUI.destroy()
        destroyed = true
    end

    if not root or destroyed then
        local root = player.gui.top.add{type="frame", name="evoGUI", direction = "horizontal", style="outer_frame_style"}

        local action_buttons = root.add{type="flow", name="action_buttons", direction = "vertical", style="description_flow_style"}
        action_buttons.add{type="button", name="evoGUI_size", caption="-", style="evoGUI_small_button_style"}
        action_buttons.add{type="button", name="evoGUI_settings", caption="s", style="evoGUI_small_button_style"}

        local sensors = root.add{type="flow", name="sensors", direction = "vertical", style="description_flow_style"}
        sensors.add{type="label", name="day_time"}
        sensors.add{type="label", name="evolution_factor"}
        sensors.add{type="label", name="play_time"}

        if not global.evoGUI then global.evoGUI = {} end
        global.evoGUI.version = "0.3.0"
    end
end

function evogui.on_click.evoGUI_size(event)
    local player = game.get_player(event.player_index)

    local sensors = player.gui.top.evoGUI.sensors
    if sensors.evolution_factor ~= nil then
        -- hide the extra bits
        sensors.evolution_factor.destroy()
        sensors.play_time.destroy()
        player.gui.top.evoGUI.action_buttons.evoGUI_size.caption = "+"
    else
        -- show the extra bits
        sensors.add{type="label", name="evolution_factor"}
        evogui.update_evolution(sensors.evolution_factor)

        sensors.add{type="label", name="play_time"}
        evogui.update_play_time(sensors.play_time)

        player.gui.top.evoGUI.action_buttons.evoGUI_size.caption = "-"
    end
end
