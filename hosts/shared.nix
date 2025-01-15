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
  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  nix.channel.enable = false;
  nixpkgs.config.allowUnfree = true;

  networking.hostName = HOST;
  users.users."${USER}" = {
    name = USER;
    home = HOME;
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
    '';
  };
  programs.zsh = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps -p $PPID -o 'comm') != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        exec ${pkgs.fish}/bin/fish
      fi
    '';
  };

  programs.fish.enable = true;
}
