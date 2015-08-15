All the globals created by evoGUI are written into the `global.evogui` table,
whose top-level keys are all player names. Thus, all evoGUI globals are
player-specific.

Globals were first used in evoGUI v0.3.0 -- earlier versions will not have
these, but v0.3.0 and later will create them as needed.

Currently, we use the following (prefix with `global.evogui[player_name]` to
access):

    - `version`: the version of evoGUI that created these settings. Primary use
    is to trigger the recreation of the evoGUI main interface when doing an
    up/downgrade.

    - `always_visible`: a `LuaTable` whose keys are names of value sensors and
    whose values are either true or nil. Used to determine whether a value
    sensor should be shown to a specific player in the _always visible_ pane.

    - `in_popup`: a `LuaTable` whose keys are names of value sensors. Used
    analogously to `always_visible` for sensors that should be shown in popup
    (i.e., when the main interface is expanded).

    - `popup_open`: a `bool` that states whether the main interface is expanded
    or not (i.e., whether `in_popup` sensors are visible or not). Changing this
    unexpectedly may leave the GUI in a weird state.
