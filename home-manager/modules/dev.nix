{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      hide_env_diff = true;
      whitelist = {
        prefix = [ "~/Documents/projects" ];
      };
    };
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      mkhl.direnv
      svelte.svelte-vscode
      teabyii.ayu
      ms-vscode-remote.vscode-remote-extensionpack
    ];
    userSettings = {
      "files.autoSave" = "afterDelay";
      "editor.formatOnSave" = true;
      "editor.fontSize" = 12;
      "editor.wordWrap" = "bounded";
      "editor.wordWrapColumn" = 120;
      "nix.enableLanguageServer" = true;
      "nix.formatterPath" = "nixfmt";
      "nix.serverPath" = "nixd";
      "editor.minimap.enabled" = false;
      "terminal.integrated.defaultProfile.osx" = "fish";
      "workbench.colorTheme" = "Ayu Mirage";
    };
  };

  programs.git = {
    enable = true;
    userName = "Wendy Chen";
    userEmail = "jaewchen@gmail.com";
    difftastic.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
