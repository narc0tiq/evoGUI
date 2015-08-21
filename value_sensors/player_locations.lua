require "template"

local sensor = ValueSensor.new("player_locations")

function sensor:create_ui(owner)
    if owner[self.name] == nil then
        local root = owner.add{type="flow",
                               name=self.name,
                               direction="horizontal",
                               style="description_flow_style"}

        root.add{type="label", caption={self.format_key}}
        root.add{type="table", name="player_list", colspan=1}
    end
end

function sensor:update_ui(owner)
    for _, p in ipairs(game.players) do
        if owner[self.name].player_list[p.name] == nil then
            owner[self.name].player_list.add{type="label", name=p.name}
        end
        local desc = string.format("%s @(%d, %d on %s)", p.name,
            p.position.x, p.position.y, p.surface.name)
        owner[self.name].player_list[p.name].caption = desc
    end
end

ValueSensor.register(sensor)
