{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      nixos-wsl,
      home-manager,
      self,
      ...
    }:
    let
      USER = "wendy";
      HOME_DARWIN = "/Users/${USER}";
      HOME_WSL = "/home/${USER}";
      HOST_DARWIN = "idunn";
      HOST_WSL = "loki";
      inherit (self) outputs;
    in
    {
      darwinConfigurations."${HOST_DARWIN}" = nix-darwin.lib.darwinSystem {
        modules = [
          ./hosts/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."${USER}" = import ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              USER = USER;
              HOME = HOME_DARWIN;
            };
          }
        ];
        specialArgs = {
          inherit
            outputs
            home-manager
            USER
            ;
          HOST = HOST_DARWIN;
          HOME = HOME_DARWIN;
        };
      };

      nixosConfigurations = (
        import ./hosts/wsl.nix {
          inherit
            nixpkgs
            nixos-wsl
            home-manager
            USER
            ;
          HOST = HOST_WSL;
          HOME = HOME_WSL;
        }
      );

      templates = {
        node = {
          path = ./templates/node;
          description = "JS/TS with PNPM and direnv";
        };
        rust = {
          path = ./templates/rust;
          description = "Rust with cargo and direnv";
        };
      };
    };
}
