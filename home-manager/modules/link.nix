{ config, HM_MODULE_DIR, ... }:

let
  link = config.lib.file.mkOutOfStoreSymlink;
  linkDir = "${HM_MODULE_DIR}/linked";
in
{
  home.file.".local/bin/scripts".source = link "${linkDir}/scripts";
  xdg.configFile."wezterm/wezterm.lua".source = link "${linkDir}/wezterm.lua";
}
