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

--[[
function sensor:settings_gui(player_index)
    local player = game.get_player(player_index)
    player.print("Hello, world")
end
]]


local function directions(source, destination)
    -- Directions to or from positionless things? Hrm.
    if not source.position or not destination.position then return '?' end

    local delta_x = destination.position.x - source.position.x
    local delta_y = destination.position.y - source.position.y

    if math.abs(delta_x) > math.abs(delta_y) then
        if delta_x < -1 then
            return '<'
        elseif delta_x > 1 then
            return '>'
        else
            return '='
        end
    else
        if delta_y < -1 then
            return '^'
        elseif delta_y > 1 then
            return 'v'
        else
            return '='
        end
    end
end


function sensor:update_ui(owner)
    for _, p in ipairs(game.players) do
        if owner[self.name].player_list[p.name] == nil then
            owner[self.name].player_list.add{type="label", name=p.name}
        end

        local direction = '?'
        local current_player = game.get_player(owner.player_index)
        if p == current_player then
            direction = ''
        elseif current_player then
            direction = directions(current_player, p)
        end

        local desc = string.format("(%d) %s @(%d, %d on %s) %s", p.index,
            p.name, p.position.x, p.position.y, p.surface.name, direction)
        owner[self.name].player_list[p.name].caption = desc
    end
end

ValueSensor.register(sensor)
