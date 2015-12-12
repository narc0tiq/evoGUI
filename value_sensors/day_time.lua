require "template"

if not evogui.on_click then evogui.on_click = {} end
local sensor = ValueSensor.new("day_time")

if remote.interfaces.MoWeather then
    -- assume MoWeather's getdaytime is sane
    function get_day_time() return remote.call("MoWeather", "getdaytime") end
else
    -- 0.5 is midnight; let's make days *start* at midnight instead.
    function get_day_time() return game.daytime + 0.5 end
end

function sensor:get_line()
    local day_time = math.fmod(get_day_time(), 1)

    local day_time_minutes = math.floor(day_time * 24 * 60)
    local day_time_hours = math.floor(day_time_minutes / 60)

    local display_minutes = day_time_minutes
    if self.settings.minute_rounding then
        display_minutes = day_time_minutes - (day_time_minutes % 15)
    end

    local brightness = math.floor((1 - game.darkness) * 100)

    if self.settings.show_day_number then
        local day_number = 1 + ((game.tick + 12500) / 25000)
        return {"sensor.day_time.day_format",
                string.format("%d:%02d", day_time_hours, display_minutes % 60),
                string.format("%d", day_number),
                string.format("%d%%", brightness)}
    else
        return {self.format_key,
                string.format("%d:%02d", day_time_hours, display_minutes % 60),
                string.format("%d%%", brightness)}
    end
end


function sensor:settings_gui(player_index)
    local player = game.get_player(player_index)
    local sensor_settings = global.evogui[player.name].sensor_settings[self.name]
    local root_name = self:settings_root_name()

    local root = player.gui.center.add{type="frame",
                                       name=root_name,
                                       direction="vertical",
                                       caption={"sensor.day_time.settings.title"}}
    root.add{type="checkbox", name="evogui_show_day_number",
             caption={"sensor.day_time.settings.show_day_number"},
             state=sensor_settings.show_day_number}
    evogui.on_click.evogui_show_day_number = self:make_on_click_checkbox_handler("show_day_number")

    root.add{type="checkbox", name="evogui_minute_rounding",
             caption={"sensor.day_time.settings.minute_rounding"},
             state=sensor_settings.minute_rounding}
    evogui.on_click.evogui_minute_rounding = self:make_on_click_checkbox_handler("minute_rounding")

    local btn_close = root.add{type="button", name="evogui_custom_sensor_close", caption={"settings_close"}}
    evogui.on_click[btn_close.name] = function(event) self:close_settings_gui(player_index) end
end


ValueSensor.register(sensor)
