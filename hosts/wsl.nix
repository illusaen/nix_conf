{
  nixpkgs,
  nixos-wsl,
  home-manager,
  USER,
  HOST,
  HOME,
  CONFIG_DIR,
  ...
}:

{
  "${HOST}" = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit USER HOME CONFIG_DIR;
    };
    modules = [
      { nix.registry.nixpkgs.flake = nixpkgs; }
      nixos-wsl.nixosModules.wsl
      {
        wsl.enable = true;
        wsl.defaultUser = USER;
        wsl.nativeSystemd = true;
      }
      ./shared.nix
      home-manager.nixosModules.home-manager
      {
        imports = [ ../home-manager/home.nix ];
      }
    ];
  };
}
