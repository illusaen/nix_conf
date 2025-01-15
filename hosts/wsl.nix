{
  nixpkgs,
  nixos-wsl,
  home-manager,
  USER,
  HOST,
  HOME,
  HM_MODULE_DIR,
  ...
}:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs { inherit system; };
in
{
  "${HOST}" = nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit
        USER
        HOME
        HOST
        HM_MODULE_DIR
        ;
    };
    modules = [
      {
        nix.registry.nixpkgs.flake = nixpkgs;
        nixpkgs.hostPlatform.system = system;
      }
      nixos-wsl.nixosModules.default
      {
        wsl.enable = true;
        wsl.defaultUser = USER;
        wsl.nativeSystemd = true;
        system.stateVersion = "24.05";
        programs.nix-ld = {
          enable = true;
        };
      }
      ./shared.nix
      home-manager.nixosModules.home-manager
      {
        imports = [
          ../home-manager/home.nix
        ];
        home-manager.users."${USER}" = {
          programs = {
            git.extraConfig.core.sshCommand = "ssh.exe";
            fish.shellAbbrs = {
              nrn = "cd $NIX_CONF; git add .; sudo nixos-rebuild switch --flake $NIX_CONF; cd -";
            };
            vscode.package = pkgs.openvscode-server;
          };
          home.activation.copyAndLinkFiles = home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            source="${HM_MODULE_DIR}/linked/wezterm.lua"
            destination="/mnt/c/Users/$USER/.config/wezterm/wezterm.lua"
            if [ ! -f "$source" ]; then
              echo "$source does not exist."
            fi
            if [ -f "$destination" ]; then
              rm "$destination"
            fi
            cp "$source" "$destination"
            echo "Copied $source to $destination"

            source="$HOME/.config/OpenVSCode Server/User/settings.json" 
            destination="$HOME/.vscode-server/data/Machine/settings.json"
            if [ ! -f "$source" ]; then
              echo "$source does not exist."
            fi
            if [ -f "$destination" ]; then
              rm "$destination"
            fi
            ln -s "$source" "$destination"
            echo "Symlinked $source to $destination"


            source="$HOME/.openvscode-server/extensions"
            destination="$HOME/.vscode-server/extensions"
            if [ -d "$source" ]; then
              echo "$source does not exist."
            fi
            if [ -d "$destination" ]; then
              rm -rf "$destination"
            fi
            ln -s "$source" "$destination"
            echo "Symlinked $source to $destination"
          '';
        };
      }
    ];
  };
}
