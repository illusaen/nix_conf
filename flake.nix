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
              (writeShellApplication {
                name = "fish_indent-wrapper";
                runtimeInputs = [
                  pkgs.findutils
                ];
                text = ''
                  fish_indent --check "$@" 2>&1 | xargs --no-run-if-empty fish_indent --write || true
                '';
              })
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
        deno = {
          path = ./templates/deno;
          description = "Deno with prettier for svelte and direnv";
        };
        go = {
          path = ./templates/go;
          description = "Go with gotools and direnv";
        };
      };
    };
}
