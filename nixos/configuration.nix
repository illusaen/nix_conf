{
  inputs,
  lib,
  pkgs,
  vars,
  ...
}: 

{
  imports = [
    ./hardware-configuration.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = vars.username;
  wsl.nativeSystemd = true;

  networking.hostName = "wsl-nixos";

  nixpkgs.config.allowUnfree = true;

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
    };
    package = pkgs.nixFlakes;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  environment.systemPackages = with pkgs; [ git wget fish helix ];
  environment.variables.EDITOR = "hx";

  users.users = {
    "${vars.username}" = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
  };

  programs.bash = {
  interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';
  };

  programs.fish.enable = true;
}
