local wezterm = require("wezterm")
local config = wezterm.config_builder()

local function is_found(str, pattern)
  return string.find(str, pattern) ~= nil
end

local function _platform()
  local is_win = is_found(wezterm.target_triple, 'windows')
  local is_mac = is_found(wezterm.target_triple, 'apple')
  local is_linux = is_found(wezterm.target_triple, 'linux')

  return { is_win = is_win, is_linux = is_linux, is_mac = is_mac, }
end
local platform = _platform()

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = platform.is_mac and 12 or 9
config.color_scheme = "Ayu Mirage"
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.initial_cols = 120
config.initial_rows = 180
if platform.is_mac then
  config.default_domain = "WSL:NixOS"
end

return config
