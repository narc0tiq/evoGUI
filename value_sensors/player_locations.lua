require "template"

local sensor = ValueSensor.new("player_locations")

function sensor:create_ui(owner)
    if owner[self.name] == nil then
        local root = owner.add{type="flow",
                               name=self.name,
                               direction="horizontal",
                               style="description_flow_style"}

        root.add{type="label", caption={self.format_key}}
        self.player_list = root.add{type="table",
                                    name="player_list",
                                    colspan=1}
    end
end

function sensor:update_ui(owner)
    if self.player_list == nil then return end

    for _, p in ipairs(game.players) do
        if self.player_list[p.name] == nil then
            self.player_list.add{type="label", name=p.name}
        end
        local desc = string.format("%s @(%d, %d on %s)", p.name,
            p.position.x, p.position.y, p.surface.name)
        self.player_list[p.name].caption = desc
    end
end

ValueSensor.register(sensor)
