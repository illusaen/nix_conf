{
  outputs,
  ...
}:

{
  imports = [ ./shared.nix ];
  system.configurationRevision = outputs.rev or outputs.dirtyRev or null;
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.stateVersion = 5;
}
