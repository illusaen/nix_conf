{ pkgs, ... }:

{
  home.packages = [ pkgs.zoxide ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd j" ];
  };
}
