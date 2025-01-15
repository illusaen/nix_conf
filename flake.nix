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

      attrs = nixpkgs.lib.attrsets;
      listTemplateDirectory =
        path:
        attrs.genAttrs
          (builtins.attrNames (
            attrs.filterAttrs (n: v: v == "directory") (
              builtins.removeAttrs (builtins.readDir path) [ "shared" ]
            )
          ))
          (name: {
            path = ./templates/name;
            description = "Template for " + name;
          });
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
          HM_MODULE_DIR = "${homeLinux}/${configDir}/home-manager/modules";
        }
      );

      templates = listTemplateDirectory ./templates;
    };
}
