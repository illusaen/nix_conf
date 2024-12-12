{ pkgs, ... }:

{
  home.packages = [ pkgs.eza ];
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };
}
