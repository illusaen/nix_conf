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
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      nixos-wsl,
      home-manager,
      systems,
      self,
      ...
    }@inputs:
    let
      USER = "wendy";
      CONFIG_DIR = "nix_conf";
      inherit (self) outputs;

      forEachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
            };
          }
        );
    in
    {
      devShells = forEachSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              shfmt
              stylua
              toml-sort
            ];
          };
        }
      );

      darwinConfigurations = (
        import ./hosts/darwin.nix {
          inherit
            nixpkgs
            nix-darwin
            home-manager
            outputs
            USER
            CONFIG_DIR
            ;
          HOST = "idunn";
          HOME = "/Users/${USER}";
          HM_MODULE_DIR = "/home/${USER}/${CONFIG_DIR}/home-manager/modules";
        }
      );

      nixosConfigurations = (
        import ./hosts/wsl.nix {
          inherit
            inputs
            nixpkgs
            nixos-wsl
            home-manager
            USER
            CONFIG_DIR
            ;
          HOST = "loki";
          HOME = "/home/${USER}";
          HM_MODULE_DIR = "/home/${USER}/${CONFIG_DIR}/home-manager/modules";
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
        python = {
          path = ./templates/python;
          description = "Python with venvshellhook";
        };
        go = {
          path = ./templates/go;
          description = "Go with gotools and direnv";
        };
      };
    };
}
