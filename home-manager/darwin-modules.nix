{ pkgs, ... }:

{
  home.packages = with pkgs; [
    raycast
    google-chrome
  ];

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      mkhl.direnv
      svelte.svelte-vscode
      teabyii.ayu
      ms-vscode-remote.vscode-remote-extensionpack
      tamasfe.even-better-toml
    ];
    userSettings = {
      "files.autoSave" = "afterDelay";
      "editor.formatOnSave" = true;
      "editor.fontSize" = 12;
      "editor.fontFamily" = "'JetBrainsMono Nerd Font'";
      "editor.fontLigatures" = true;
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
}