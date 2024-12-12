local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 12.0
config.front_end = "WebGpu"
config.color_scheme = 'Ayu Mirage'

return config
