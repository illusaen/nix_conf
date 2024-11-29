# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "dev";
    homeDirectory = "/home/dev";
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };
  
  home.packages = with pkgs; [ helix fish git bat eza fzf ];

  programs.home-manager.enable = true;

  programs.fish.enable = true;
  programs.git = {
    enable = true;
    userName = "Wendy Chen";
    userEmail = "jaewchen@gmail.com";
  };
  programs.git.extraConfig = {
    init.defaultBranch = "main";
  };
  
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
