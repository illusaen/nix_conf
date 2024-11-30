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
    devenv.url = "github:cachix/devenv";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    {
      self,
      nixpkgs,
      NixOS-WSL,
      home-manager,
      devenv,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      vars = {
        username = "dev";
        home = "/home/${vars.username}";
        nix_conf = "/home/${vars.username}/nix_conf";
      };
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages."${system}" = {
        devenv-up = self.devShells.${system}.default.config.procfileScript;
        devenv-test = self.devShells."${system}".default.config.test;
      };

      devShells."${system}".default = devenv.lib.mkShell {
        inherit inputs pkgs;
        modules = [
          (
            { pkgs, ... }:
            {
              packages = [ pkgs.nixfmt-rfc-style ];
              languages.nix = {
                enable = true;
                lsp.package = pkgs.nixd;
              };
            }
          )
        ];
      };

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = (
        import ./hosts/wsl.nix {
          inherit
            inputs
            outputs
            nixpkgs
            NixOS-WSL
            home-manager
            vars
            ;
        }
      );
    };
}
