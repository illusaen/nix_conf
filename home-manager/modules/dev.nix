{
  pkgs,
  lib,
  config,
  HM_MODULE_DIR,
  ...
}:

{
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    treefmt2
  ];

  programs.gh.enable = true;

  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${HM_MODULE_DIR}/wezterm/wezterm.lua";

  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "bash";
      copy_on_select = true;
      theme = "ayu_mirage";
    };
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    config = {
      hide_env_diff = true;
    };
  };

  programs.lazygit.enable = true;

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
    ];
  };
}
