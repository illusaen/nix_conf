{
  config,
  HM_MODULE_DIR,
  ...
}:

{
  programs.wezterm.enable = true;
  home.file.".wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${HM_MODULE_DIR}/wezterm/wezterm.lua";
}
