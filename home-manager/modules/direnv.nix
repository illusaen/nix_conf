{ pkgs, ... }:

{
  home.packages = [ pkgs.direnv ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
