{
  pkgs,
  lib,
  ...
}:

{
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    treefmt2
  ];

  programs = {
    bat.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    eza = {
      enable = true;
      icons = "auto";
      git = true;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    zoxide = {
      enable = true;
      options = [ "--cmd j" ];
    };
    starship = {
      enable = true;
      enableFishIntegration = true;
    };

    gh.enable = true;
    lazygit.enable = true;
    zellij = {
      enable = true;
      settings = {
        default_shell = "bash";
        copy_on_select = true;
        theme = "ayu_mirage";
      };
    };
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
        whitelist.prefix = [ "~/projects" ];
      };
    };
    git = {
      enable = true;
      userName = "Wendy Chen";
      userEmail = "jaewchen@gmail.com";
      difftastic.enable = true;
      extraConfig = lib.mkMerge [
        {
          init.defaultBranch = "main";
          push.autoSetupRemote = true;
        }
      ];
    };
  };
}
