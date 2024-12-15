{
  pkgs,
  config,
  HM_MODULE_DIR,
  ...
}:

{
  home.packages = with pkgs; [
    lunarvim
  ];

  xdg.configFile."lvim/config.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${HM_MODULE_DIR}/lunarvim/config.lua";
}
