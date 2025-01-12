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
      configDir = "nix_conf";
      homeLinux = "/home/${USER}";
      homeMac = "/Users/${USER}";
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
            ;
          HOST = "idunn";
          HOME = homeMac;
          CONFIG_DIR = "${homeMac}/${configDir}";
          HM_MODULE_DIR = "${homeMac}/${configDir}/home-manager/modules";
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
            ;
          HOST = "loki";
          HOME = homeLinux;
          CONFIG_DIR = "${homeLinux}/${configDir}";
          HM_MODULE_DIR = "${homeLinux}/${configDir}/home-manager/modules";
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
