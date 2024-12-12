local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font('JetBrainsMono Nerd Font')
config.font_size = 11.0
config.front_end = "WebGpu"
config.color_scheme = 'Ayu Mirage'
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

return config
