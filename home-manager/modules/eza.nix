{ pkgs, ... }:

{
  home.packages = [ pkgs.eza ];
  programs.eza = {
    enable = true;
    icons = true;
    git = true;
  };
}
