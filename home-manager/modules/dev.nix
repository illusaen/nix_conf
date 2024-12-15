{ pkgs, lib, ... }:

let 
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in 
{
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
  ];

  programs.gh.enable = true;

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    config = {
      hide_env_diff = true;
      whitelist = {
        prefix = [
          (if isDarwin then "~/Documents/projects" else "~/projects")
        ];
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Wendy Chen";
    userEmail = "jaewchen@gmail.com";
    difftastic.enable = true;
    extraConfig = lib.mkMerge [
      {
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      }
      (lib.mkIf (!isDarwin) { core.sshCommand = "ssh.exe"; })
    ];
  };
}
