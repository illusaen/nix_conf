{ pkgs, ... }:

{
  home.packages = [ pkgs.starship ];
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  xdg.configFile."starship.toml".source = ./starship.toml;
}
