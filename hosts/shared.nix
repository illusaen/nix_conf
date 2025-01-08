{
  pkgs,
  USER,
  HOST,
  HOME,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    helix
    wget
  ];
  environment.variables.EDITOR = "hx";

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [
    USER
    "@wheel"
  ];
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;

  networking.hostName = HOST;
  users.users."${USER}" = {
    name = USER;
    home = HOME;
    shell = pkgs.bash;
  };

  programs.bash = {
    blesh.enable = true;
  };
}
