{
  nixpkgs,
  nixos-wsl,
  home-manager,
  USER,
  HOST,
  HOME,
  CONFIG_DIR,
  HM_MODULE_DIR,
  ...
}:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };
in
{
  "${HOST}" = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit
        USER
        HOME
        CONFIG_DIR
        HOST
        HM_MODULE_DIR
        ;
    };
    modules = [
      {
        nix.registry.nixpkgs.flake = nixpkgs;
        nixpkgs.hostPlatform.system = system;
        programs._wezterm.enable = true;
      }
      nixos-wsl.nixosModules.default
      {
        wsl.enable = true;
        wsl.defaultUser = USER;
        wsl.nativeSystemd = true;
        system.stateVersion = "24.05";
        programs.nix-ld = {
          enable = true;
          package = pkgs.nix-ld-rs; # only for NixOS 24.05
        };
      }
      ./shared.nix
      ./wsl-wezterm.nix
      home-manager.nixosModules.home-manager
      {
        imports = [ ../home-manager/home.nix ];
      }
    ];
  };
}
