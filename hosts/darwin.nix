{
  nixpkgs,
  outputs,
  nix-darwin,
  home-manager,
  USER,
  HOST,
  HOME,
  HM_MODULE_DIR,
  ...
}:

let
  system = "aarch64-darwin";
  pkgs = import nixpkgs { inherit system; };
in
{
  "${HOST}" = nix-darwin.lib.darwinSystem {
    modules = [
      {
        system.configurationRevision = outputs.rev or outputs.dirtyRev or null;
        nixpkgs.hostPlatform = system;
        system.stateVersion = 5;

        fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

        networking.computerName = HOST;
        system.defaults.smb.NetBIOSName = HOST;

        programs._1password-gui.enable = true;
        programs._1password.enable = false;
      }
      ./shared.nix
      ./darwin-1password.nix
      home-manager.darwinModules.home-manager
      {
        imports = [
          ../home-manager/home.nix
        ];
        home-manager.users."${USER}" = {
          home.packages = with pkgs; [
            raycast
            google-chrome
          ];
          programs = {
            fish.shellAbbrs = {
              nrn = "cd $NIX_CONF; git add .; darwin-rebuild switch --flake $NIX_CONF; cd -";
            };
            wezterm.enable = true;
            vscode.package = pkgs.vscode;
          };
        };
      }
    ];
    specialArgs = {
      inherit
        USER
        HOST
        HOME
        HM_MODULE_DIR
        ;
    };
  };
}
