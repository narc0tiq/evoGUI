require "template"

local sensor = ValueSensor.new("evolution_factor")


function sensor:get_line()
    if self.settings.extra_precision then
        return {self.format_key, string.format("%0.4f%%", game.evolution_factor * 100)}
    end

    return {self.format_key, string.format("%0.1f%%", game.evolution_factor * 100)}
end


function sensor:settings_gui(player_index)
    local player = game.get_player(player_index)
    local sensor_settings = global.evogui[player.name].sensor_settings[self.name]
    local root_name = self:settings_root_name()

    local root = player.gui.center.add{type="frame",
                                       name=root_name,
                                       direction="vertical",
                                       caption={"sensor.evolution_factor.settings.title"}}
    root.add{type="checkbox", name="evogui_extra_precision",
             caption={"sensor.evolution_factor.settings.extra_precision"},
             state=sensor_settings.extra_precision}
    evogui.on_click.evogui_extra_precision = self:make_on_click_checkbox_handler("extra_precision")

    local btn_close = root.add{type="button", name="evogui_custom_sensor_close", caption={"settings_close"}}
    evogui.on_click[btn_close.name] = function(event) self:close_settings_gui(player_index) end
end

ValueSensor.register(sensor)
