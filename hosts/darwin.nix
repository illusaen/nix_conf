{
  outputs,
  nix-darwin,
  home-manager,
  USER,
  HOST,
  HOME,
  CONFIG_DIR,
  ...
}:

{
  "${HOST}" = nix-darwin.lib.darwinSystem {
    modules = [
      {
        system.configurationRevision = outputs.rev or outputs.dirtyRev or null;
        nixpkgs.hostPlatform = "aarch64-darwin";
        system.stateVersion = 5;
      }
      ./shared.nix
      ./darwin-1password.nix
      home-manager.darwinModules.home-manager
      {
        imports = [ ../home-manager/home.nix ];
      }
    ];
    specialArgs = {
      inherit
        USER
        HOST
        HOME
        CONFIG_DIR
        ;
    };
  };
}
