require "template"

local sensor = ValueSensor.new("play_time")


function sensor:get_line()
    local play_time_seconds = math.floor(game.tick/60)
    local play_time_minutes = math.floor(play_time_seconds/60)
    local play_time_hours = math.floor(play_time_minutes/60)
    local play_time_days = math.floor(play_time_hours/24)

    local desc = {""}
    if play_time_days > 0 and self.settings.show_days then
        if play_time_days == 1 then
            table.insert(desc, {"sensor.play_time.single_day_fragment"})
        else
            table.insert(desc, {"sensor.play_time.multi_day_fragment", tostring(play_time_days)})
        end
        table.insert(desc, ' ')
        play_time_hours = play_time_hours % 24
    end

    if self.settings.show_seconds then
        table.insert(desc, string.format("%d:%02d:%02d", play_time_hours, play_time_minutes % 60, play_time_seconds % 60))
    else
        table.insert(desc, string.format("%d:%02d", play_time_hours, play_time_minutes % 60))
    end

    return {self.format_key, desc}
end


function sensor:settings_gui(player_index)
    local player = game.get_player(player_index)
    local sensor_settings = global.evogui[player.name].sensor_settings[self.name]
    local root_name = self:settings_root_name()

    local root = player.gui.center.add{type="frame",
                                       name=root_name,
                                       direction="vertical",
                                       caption={"sensor.play_time.settings.title"}}
    root.add{type="checkbox", name="evogui_show_days",
             caption={"sensor.play_time.settings.show_days"},
             state=sensor_settings.show_days}
    evogui.on_click.evogui_show_days = self:make_on_click_checkbox_handler("show_days")

    root.add{type="checkbox", name="evogui_show_seconds",
             caption={"sensor.play_time.settings.show_seconds"},
             state=sensor_settings.show_seconds}
    evogui.on_click.evogui_show_seconds = self:make_on_click_checkbox_handler("show_seconds")

    local btn_close = root.add{type="button", name="evogui_custom_sensor_close", caption={"settings_close"}}
    evogui.on_click[btn_close.name] = function(event) self:close_settings_gui(player_index) end
end


ValueSensor.register(sensor)
