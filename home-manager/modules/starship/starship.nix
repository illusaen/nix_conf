{ config, HM_MODULE_DIR, ... }:

{
  programs.starship.enable = true;
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${HM_MODULE_DIR}/starship/starship.toml";
}
