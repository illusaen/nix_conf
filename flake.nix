{
  description = "Home Manager configuration for dev";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    NixOS-WSL = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    NixOS-WSL,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    vars = {
      username = "dev";
      home = "/home/${vars.username}";
      nix_conf = "/home/${vars.username}/nix_conf";
    };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      wsl-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs vars;};
        modules = [
          { nix.registry.nixpkgs.flake = nixpkgs; }
          NixOS-WSL.nixosModules.wsl
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${vars.username}" = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = { inherit inputs outputs vars; };
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    # homeConfigurations = {
    #   "dev@wsl-nixos" = home-manager.lib.homeManagerConfiguration {
    #     pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
    #     extraSpecialArgs = {inherit inputs outputs;};
    #     # > Our main home-manager configuration file <
    #     modules = [./home-manager/home.nix];
    #   };
    # };
  };
}
