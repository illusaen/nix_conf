{
  nixpkgs,
  nixos-wsl,
  home-manager,
  USER,
  HOST,
  HOME,
  HM_MODULE_DIR,
  ...
}:

let
  system = "x86_64-linux";
in
{
  "${HOST}" = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit
        USER
        HOME
        HOST
        HM_MODULE_DIR
        ;
    };
    modules = [
      {
        nix.registry.nixpkgs.flake = nixpkgs;
        nixpkgs.hostPlatform.system = system;
      }
      nixos-wsl.nixosModules.default
      {
        wsl.enable = true;
        wsl.defaultUser = USER;
        wsl.nativeSystemd = true;
        system.stateVersion = "24.05";
        programs.nix-ld = {
          enable = true;
        };
      }
      ./shared.nix
      home-manager.nixosModules.home-manager
      {
        imports = [ ../home-manager/home.nix ];
      }
    ];
  };
}
