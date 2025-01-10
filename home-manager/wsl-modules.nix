{
  USER,
  HOST,
  ...
}:

{
  programs.direnv.config.whitelist.prefix = [
    "~/projects"
  ];
  programs.git.extraConfig.core.sshCommand = "ssh.exe";

  home.sessionPath = [
    "/mnt/c/Users/${USER}/AppData/Local/Microsoft/WinGet/Packages/equalsraf.win32yank_Microsoft.Winget.Source_8wekyb3d8bbwe"
  ];

  programs.bash.shellAliases = {
    nrn = "cd $NIX_CONF; git add .; sudo nixos-rebuild switch --flake $NIX_CONF#${HOST}; cd -";
  };
}
