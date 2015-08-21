if not evogui then evogui = { log = function() end } end


local function get_player_by_name(player_name)
    for _, p in pairs(game.players) do
        if p.name == player_name then
            return p
        end
    end
    return nil
end


local function remote_rebuild(player_name)
    if not player_name then
        evogui.log({"err_needplayername"})
        return
    end

    player = get_player_by_name(player_name)
    if not player then
        evogui.log({"err_nosuchplayer", tostring(player_name)})
        return
    end

    if not global.evogui or not global.evogui[player_name] then
        evogui.log({"err_noplayerdata", player_name})
        return
    end

    global.evogui[player.name].version = ""
end


interface = {
    rebuild = function(player_name)
        local status, err = pcall(remote_rebuild, player_name)
        if err then evogui.log({"err_generic", "interface.rebuild", err}) end
    end
}


remote.add_interface("EvoGUI", interface)
