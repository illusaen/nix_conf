# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    #<nixos-wsl/modules>
    /etc/nixos/configuration.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  wsl.enable = true;
  wsl.defaultUser = "dev";

  nixpkgs.config.allowUnfree = true;

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
    };
    # Opinionated: disable channels
    #channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    #registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    #nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };


  networking.hostName = "wsl-nixos";

  users.users = {
    dev = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[_$(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" &&
        -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };

  programs.fish.enable = true;
  
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
