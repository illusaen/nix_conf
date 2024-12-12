{
  outputs,
  nix-darwin,
  home-manager,
  USER,
  HOST,
  HOME,
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
      home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users."${USER}" = import ../home-manager/home.nix;
        home-manager.extraSpecialArgs = { inherit USER HOME; };
      }
    ];
    specialArgs = { inherit USER HOST HOME; };
  };
}
