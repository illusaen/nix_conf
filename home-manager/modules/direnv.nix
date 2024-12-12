{ pkgs, ... }:

{
  home.packages = [ pkgs.direnv ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      hide_env_diff = true;
      whitelist = {
        prefix = [ "~/Documents/projects" ];
      };
    };
  };
}
