{ config, HM_MODULE_DIR, ... }:

let
  link = config.lib.file.mkOutOfStoreSymlink;
  linkDir = "${HM_MODULE_DIR}/linked";
in
{
  home.file.".local/bin/scripts".source = link ./linked/scripts;
  xdg.configFile."wezterm/wezterm.lua".source = link ./linked/wezterm.lua;
  xdg.configFile."fish/conf.d/autols.fish".source = link ./linked/autols.fish;
  xdg.configFile."fish/functions/dev-shell.fish".source = link ./linked/dev-shell.fish;
  xdg.configFile."helix/config.toml".source = link ./linked/helix-config.toml;
  xdg.configFile."helix/languages.toml".source = link ./linked/helix-languages.toml;
  xdg.configFile."lvim/config.lua".source = link ./linked/lvim-config.lua;
  xdg.configFile."starship.toml".source = link ./linked/starship.toml;
}
