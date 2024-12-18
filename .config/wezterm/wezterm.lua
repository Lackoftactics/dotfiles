local wezterm = require("wezterm")
local act = wezterm.action
local mappings = require("modules.mappings")



local function rails_project_keybindings(cwd)
  return {
    {
      key = 'c',
      mods = 'CTRL|SHIFT',
      action = act.SpawnCommandInNewWindow({
        args = { 'wezterm', 'cli', 'spawn', '--cwd', cwd, 'rails', 'console' }
      }),
    },
    {
      key = 's',
      mods = 'CTRL|SHIFT',
      action = act.SpawnCommandInNewWindow({
        args = { 'wezterm', 'cli', 'spawn', '--cwd', cwd, 'rs' }
      }),
    },
    {
      key = 'w',
      mods = 'CTRL|SHIFT',
      action = act.SpawnCommandInNewWindow({
        args = { 'wezterm', 'cli', 'spawn', '--cwd', cwd, 'yarn', 'ds' }
      }),
    },
    {
      key = 'l',
      mods = 'CTRL|SHIFT',
      action = act.SpawnCommandInNewWindow({
        args = { 'wezterm', 'cli', 'spawn', '--cwd', cwd, 'tail', '-f', 'log/development.log' }
      }),
    },
  }
end


-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
    local name = window:active_key_table()
    if name then
        name = "TABLE: " .. name
    end
    window:set_right_status(name or "")
end)

return {
    default_cursor_style = "BlinkingBlock",
    color_scheme = "Poimandres",
    colors = {
        cursor_bg = "#A6ACCD",
        cursor_border = "#A6ACCD",
        cursor_fg = "#1B1E28"
    },
    -- font
    font = wezterm.font("FiraCode Nerd Font Mono", {
        weight = "Medium"
    }),
    font_size = 15,
    line_height = 1,
    window_background_opacity = 0.9,
    -- tab bar
    use_fancy_tab_bar = false,
    tab_bar_at_bottom = true,
    hide_tab_bar_if_only_one_tab = true,
    tab_max_width = 999999,
    window_padding = {
        left = 30,
        right = 30,
        top = 30,
        bottom = 30
    },
    background = {
      {
          source = {
              File = "/Users/pmroczek/backgrounds/cyberpunk.jpeg",
          },
          -- Adjust the opacity of the background image
          opacity = 0.9,
          -- Specify the horizontal and vertical alignment of the image
          hsb = {
              brightness = 0.4,
              hue = 1.0,
              saturation = 1.0,
          },
      },
  },

    window_decorations = "RESIZE",
    inactive_pane_hsb = {
        brightness = 0.7
    },
    send_composed_key_when_left_alt_is_pressed = false,
    send_composed_key_when_right_alt_is_pressed = true,
    -- key bindings
    leader = mappings.leader,
    keys = {
      -- Twoje obecne keys...
      {
        key = 'r',
        mods = 'CTRL|SHIFT',
        action = act.ActivateKeyTable {
          name = 'rails_commands',
          one_shot = false,
        },
      },
    },
    key_tables = {
    }
}
