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
  networking.computerName = HOST;
  system.defaults.smb.NetBIOSName = HOST;
  users.users."${USER}" = {
    name = USER;
    home = HOME;
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
  programs.fish.enable = true;
}
