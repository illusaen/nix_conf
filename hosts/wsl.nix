{
  inputs,
  outputs,
  nixpkgs,
  NixOS-WSL,
  home-manager,
  vars,
  ...
}:

{
  wsl-nixos = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs outputs vars;
    };
    modules = [
      { nix.registry.nixpkgs.flake = nixpkgs; }
      NixOS-WSL.nixosModules.wsl
      ../nixos/configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${vars.username}" = import ../home-manager/home.nix;
        home-manager.extraSpecialArgs = {
          inherit inputs outputs vars;
        };
      }
    ];
  };
}
