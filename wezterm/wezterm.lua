-- Pull in wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration
local config = wezterm.config_builder()

config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 15

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.color_scheme = "Catppuccin Macchiato"

return config
