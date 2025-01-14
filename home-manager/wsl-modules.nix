{
  HOST,
  pkgs,
  ...
}:

{
  programs.direnv.config.whitelist.prefix = [
    "~/projects"
  ];
  programs.git.extraConfig.core.sshCommand = "ssh.exe";

  programs.fish.shellAbbrs = {
    nrn = "cd $NIX_CONF; git add .; sudo nixos-rebuild switch --flake $NIX_CONF#${HOST}; cd -";
  };
  programs.vscode = {
    package = pkgs.openvscode-server;
    userSettings = {
      "security.allowedUNCHosts" = [ "rpi4.local" ];
    };
  };
}
