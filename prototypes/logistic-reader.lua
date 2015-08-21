local logistic_reader_item = {
}

local logistic_reader_recipe = {
}

local logistic_reader_entity = {
}

local invisible_inserter = {
    type = "inserter",
    name = "evogui-hidden-inserter",
    icon = "__EvoGUI__/graphics/nil.png",
    flags = {"placeable-neutral", "player-creation", "not-on-map"},
    minable = {hardness = 0.2, mining_time = 0.5, result = "evogui-logistic-reader"},
    max_health = 40,
    corpse = "small-remnants",
    order = "z[zebra]",
    resistances = {{
        type = "fire",
        percent = 90
    }},
    collision_box = {{-0, -0}, {0, 0}},
    selection_box = {{-0, -0}, {0, 0}},
    pickup_position = {0, -1},
    insert_position = {0, 1.2},
    energy_per_movement = 7000,
    energy_per_rotation = 7000,
    energy_source = {
        type = "burner",
        usage_priority = "secondary-input",
        drain = "0.0kW",
        effectivity=1,
        fuel_inventory_size=1,
    },
    extension_speed = 0.07,
    rotation_speed = 0.04,
    fast_replaceable_group = "inserter",
    filter_count = 5,
    hand_base_picture = {
        filename = "__EvoGUI__/graphics/nil.png",
        priority = "extra-high",
        width = 1,
        height = 1
    },
    hand_closed_picture = {
        filename = "__EvoGUI__/graphics/nil.png",
        priority = "extra-high",
        width = 1,
        height = 1
    },
    hand_open_picture = {
        filename = "__EvoGUI__/graphics/nil.png",
        priority = "extra-high",
        width = 1,
        height = 1
    },
    hand_base_shadow = {
        filename = "__EvoGUI__/graphics/nil.png",
        priority = "extra-high",
        width = 1,
        height = 1
    },
    hand_closed_shadow = {
        filename = "__EvoGUI__/graphics/nil.png",
        priority = "extra-high",
        width = 1,
        height = 1
    },
    hand_open_shadow = {
        filename = "__EvoGUI__/graphics/nil.png",
        priority = "extra-high",
        width = 1,
        height = 1
    },
    platform_picture = {
        sheet = {
            filename="__EvoGUI__/graphics/nil.png",
            priority = "extra-high",
            width = 1,
            height = 1
        }
    },
    programmable = true,
    rotation_speed = 0.035,
    uses_arm_movement = "basic-inserter",
}

data:extend({invisible_inserter})
