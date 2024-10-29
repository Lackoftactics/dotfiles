local colors = require("colors")

return {
    paddings = 3,
    group_paddings = 5,
    bar = {
        height = 36,
        padding = {
            x = 10,
            y = 0
        },
        background = colors.bar.bg
    },
    items = {
        height = 26,
        gap = 5,
        padding = {
            right = 16,
            left = 12,
            top = 0,
            bottom = 0
        },
        colors = {
            selected = colors.yellow,
            unselected = colors.with_alpha(colors.white, 0.7),
            background = colors.bg1
        },
        corner_radius = 6 
    },

    icons = "sketchybar-app-font:Regular:16.0", -- alternatively available: NerdFont

    font = {
        text = "FiraCode Nerd Font Mono", -- Used for text
        numbers = "FiraCode Nerd Font Mono", -- Used for numbers
        style_map = {
            ["Regular"] = "Regular",
            ["Semibold"] = "Medium",
            ["Bold"] = "SemiBold",
            ["Heavy"] = "Bold",
            ["Black"] = "ExtraBold"
        }
    }
}
