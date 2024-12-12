{
  nixpkgs,
  nixos-wsl,
  home-manager,
  USER,
  HOST,
  HOME,
  ...
}:

{
  "${HOST}" = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit USER;
    };
    modules = [
      { nix.registry.nixpkgs.flake = nixpkgs; }
      nixos-wsl.nixosModules.wsl
      (
        { ... }:
        {
          wsl.enable = true;
          wsl.defaultUser = USER;
          wsl.nativeSystemd = true;
        }
      )
      ./shared.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${USER}" = import ../home-manager/home.nix;
        home-manager.extraSpecialArgs = {
          inherit USER HOME;
        };
      }
    ];
  };
}
