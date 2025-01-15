{ config, HM_MODULE_DIR, ... }:

let
  link = config.lib.file.mkOutOfStoreSymlink;
  linkDir = "${HM_MODULE_DIR}/linked";
in
{
  home.file.".local/bin/scripts".source = link "${linkDir}/scripts";
  xdg.configFile."wezterm/wezterm.lua".source = link "${linkDir}/wezterm.lua";
  xdg.configFile."fish/conf.d/autols.fish".source = link "${linkDir}/autols.fish";
  xdg.configFile."fish/functions/dev-shell.fish".source = link "${linkDir}/dev-shell.fish";
  xdg.configFile."helix/config.toml".source = link "${linkDir}/helix-config.toml";
  xdg.configFile."helix/languages.toml".source = link "${linkDir}/helix-languages.toml";
  xdg.configFile."lvim/config.lua".source = link "${linkDir}/lvim-config.lua";
  xdg.configFile."starship.toml".source = link "${linkDir}/starship.toml";
}
