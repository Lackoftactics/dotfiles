local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}

local workspaces = get_workspaces()
local current_workspace = get_current_workspace()
local function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
        table.insert(result, each)
    end
    return result
end

for i, workspace in ipairs(workspaces) do
    local selected = workspace == current_workspace
    local space = sbar.add("item", "item." .. i, {
        icon = {
            font = {
                family = settings.font.numbers
            },
            string = i,
            padding_left = settings.items.padding.left,
            padding_right = settings.items.padding.left / 2,
            color = settings.items.colors.unselected,
            highlight_color = settings.items.colors.selected,
            highlight = selected
        },
        label = {
            padding_right = settings.items.padding.right,
            color = settings.items.colors.unselected,
            highlight_color = settings.items.colors.selected,
            font = settings.icons,
            y_offset = -1,
            highlight = selected
        },
        padding_right = 1,
        padding_left = 1,
        background = {
            color = settings.items.colors.background,
            border_width = 1,
            height = settings.items.height,
            border_color = selected and settings.items.colors.selected or settings.items.colors.unselected
        },
        popup = {
            background = {
                border_width = 5,
                border_color = colors.black
            }
        }
    })

    spaces[i] = space

    -- Define the icons for open apps on each space initially
    sbar.exec("aerospace list-windows --workspace " .. i .. " --format '%{app-name}' --json ", function(apps)
        local icon_line = ""
        local no_app = true
        for i, app in ipairs(apps) do
            no_app = false
            local app_name = app["app-name"]
            local lookup = app_icons[app_name]
            local icon = ((lookup == nil) and app_icons["default"] or lookup)
            icon_line = icon_line .. " " .. icon
        end

        if no_app then
            icon_line = " —"
        end

        sbar.animate("tanh", 10, function()
            space:set({
                label = icon_line
            })
        end)
    end)

    -- Padding space between each item
    sbar.add("item", "item." .. i .. "padding", {
        script = "",
        width = settings.items.gap
    })

    -- Item popup
    local space_popup = sbar.add("item", {
        position = "popup." .. space.name,
        padding_left = 5,
        padding_right = 0,
        background = {
            drawing = true,
            image = {
                corner_radius = 9,
                scale = 0.2
            }
        }
    })

    space:subscribe("aerospace_workspace_change", function(env)
        local selected = env.FOCUSED_WORKSPACE == workspace
        space:set({
            icon = {
                highlight = selected
            },
            label = {
                highlight = selected
            },
            background = {
                border_color = selected and settings.items.colors.selected or settings.items.colors.unselected
            }
        })

        if selected then
            sbar.exec("aerospace list-windows --workspace " .. env.FOCUSED_WORKSPACE ..
                          " --format '%{app-name}' --json ", function(apps)
                local icon_line = ""
                local no_app = true
                for i, app in ipairs(apps) do
                    no_app = false
                    local app_name = app["app-name"]
                    local lookup = app_icons[app_name]
                    local icon = ((lookup == nil) and app_icons["default"] or lookup)
                    icon_line = icon_line .. " " .. icon
                end

                if no_app then
                    icon_line = " —"
                end

                sbar.animate("tanh", 10, function()
                    space:set({
                        label = icon_line
                    })
                end)
            end)
        end
    end)

    space:subscribe("aerospace_focus_change", function()
        if selected then
            sbar.exec("aerospace list-windows --workspace " .. env.FOCUSED_WORKSPACE ..
                          " --format '%{app-name}' --json ", function(apps)
                local icon_line = ""
                local no_app = true
                for i, app in ipairs(apps) do
                    no_app = false
                    local app_name = app["app-name"]
                    local lookup = app_icons[app_name]
                    local icon = ((lookup == nil) and app_icons["default"] or lookup)
                    icon_line = icon_line .. " " .. icon
                end

                if no_app then
                    icon_line = " —"
                end
 
                sbar.animate("tanh", 10, function()
                    space:set({
                        label = icon_line
                    })
                end)
            end)
        end
    end)

    -- space:subscribe("space_change", function(env)
    --   local selected = env.SELECTED == "true"
    --   local color = selected and colors.grey or colors.bg2
    --   space:set({
    --     icon = { highlight = selected, },
    --     label = { highlight = selected },
    --     background = { border_color = selected and colors.black or colors.bg2 }
    --   })
    --   space_bracket:set({
    --     background = { border_color = selected and colors.grey or colors.bg2 }
    --   })
    -- end)

    space:subscribe("mouse.clicked", function(env)
        local SID = split(env.NAME, ".")[2]
        if env.BUTTON == "other" then
            space_popup:set({
                background = {
                    image = "item." .. SID
                }
            })
            space:set({
                popup = {
                    drawing = "toggle"
                }
            })
        else
            sbar.exec("aerospace workspace " .. SID)
        end
    end)

    space:subscribe("mouse.exited", function(_)
        space:set({
            popup = {
                drawing = false
            }
        })
    end)
end

local space_window_observer = sbar.add("item", {
    drawing = false,
    updates = true
})

-- Handles the small icon indicator for spaces / menus changes
local spaces_indicator = sbar.add("item", {
    padding_left = -3,
    padding_right = 0,
    icon = {
        padding_left = 8,
        padding_right = 9,
        color = colors.grey,
        string = icons.switch.on
    },
    label = {
        width = 0,
        padding_left = 0,
        padding_right = 8,
        string = "Spaces",
        color = colors.bg1
    },
    background = {
        color = colors.with_alpha(colors.grey, 0.0),
        border_color = colors.with_alpha(colors.bg1, 0.0)
    }
})

-- Event handles
space_window_observer:subscribe("space_windows_change", function(env)
    sbar.exec("aerospace list-windows --workspace " .. env.INFO.space .. " --format '%{app-name}' --json ",
        function(apps)
            local icon_line = ""
            local no_app = true
            for i, app in ipairs(apps) do
                no_app = false
                local app_name = app["app-name"]
                local lookup = app_icons[app_name]
                local icon = ((lookup == nil) and app_icons["default"] or lookup)
                icon_line = icon_line .. " " .. icon
            end

            if no_app then
                icon_line = " —"
            end

            sbar.animate("tanh", 10, function()
                spaces[env.INFO.space]:set({
                    label = icon_line
                })
            end)
        end)

    -- local icon_line = ""
    -- local no_app = true
    -- for app, count in pairs(env.INFO.apps) do
    --   no_app = false
    --   local lookup = app_icons[app]
    --   local icon = ((lookup == nil) and app_icons["default"] or lookup)
    --   icon_line = icon_line .. " " .. icon
    -- end

    -- if (no_app) then
    --   icon_line = " —"
    -- end
    -- sbar.animate("tanh", 10, function()
    --   spaces[env.INFO.space]:set({ label = icon_line })
    -- end)
end)

-- space_window_observer:subscribe("aerospace_focus_change", function()
--     sbar.exec("aerospace list-windows --workspace focused --format '%{app-name}' --json ", function(apps)
--         local icon_line = ""
--         local no_app = true
--         for i, app in ipairs(apps) do
--             no_app = false
--             local app_name = app["app-name"]
--             local lookup = app_icons[app_name]
--             local icon = ((lookup == nil) and app_icons["default"] or lookup)
--             icon_line = icon_line .. " " .. icon
--         end

--         if no_app then
--             icon_line = " —"
--         end

--         sbar.animate("tanh", 10, function()
--             spaces[env.INFO.space]:set({
--                 label = icon_line
--             })
--         end)
--     end)
-- end)

space_window_observer:subscribe("aerospace_workspace_change", function(env)
    sbar.exec("aerospace list-windows --workspace " .. env.FOCUSED_WORKSPACE .. " --format '%{app-name}' --json ",
        function(apps)
            local icon_line = ""
            local no_app = true
            for i, app in ipairs(apps) do
                no_app = false
                local app_name = app["app-name"]
                local lookup = app_icons[app_name]
                local icon = ((lookup == nil) and app_icons["default"] or lookup)
                icon_line = icon_line .. " " .. icon
            end

            if no_app then
                icon_line = " —"
            end

            sbar.animate("tanh", 10, function()
                if spaces[env.FOCUSED_WORKSPACE] then
                    spaces[env.FOCUSED_WORKSPACE]:set({
                        label = icon_line
                    })
                end
            end)
        end)
end)

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
    local currently_on = spaces_indicator:query().icon.value == icons.switch.on
    spaces_indicator:set({
        icon = currently_on and icons.switch.off or icons.switch.on
    })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = {
                    alpha = 1.0
                },
                border_color = {
                    alpha = 1.0
                }
            },
            icon = {
                color = colors.bg1
            },
            label = {
                width = "dynamic"
            }
        })
    end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = {
                    alpha = 0.0
                },
                border_color = {
                    alpha = 0.0
                }
            },
            icon = {
                color = colors.grey
            },
            label = {
                width = 0
            }
        })
    end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
    sbar.trigger("swap_menus_and_spaces")
end)