data:extend({
    {
        type = "font",
        name = "evoGUI_small_font",
        from = "default",
        size = 10,
    },
})

local evoGUI_small_button_style = {
    type = "button_style",
    parent = "button_style",
    font = "evoGUI_small_font",
    scalable = false,
    width = 20,
    height = 20,
    top_padding = 0,
    bottom_padding = 0,
    left_padding = 0,
    right_padding = 0,
}

data.raw["gui-style"].default["evoGUI_small_button_style"] = evoGUI_small_button_style
