{ pkgs, lib, ... }:

let
  plugins = (import ./vscode-custom-plugins.nix) {
    pkgs = pkgs;
    lib = lib;
  };
in
{
  imports = [
    ./modules/wezterm/wezterm.nix
  ];

  home.packages = with pkgs; [
    raycast
    google-chrome
  ];

  programs.vscode = {
    enable = true;
    extensions =
      with pkgs.vscode-extensions;
      [
        jnoortheen.nix-ide
        mkhl.direnv
        svelte.svelte-vscode
        teabyii.ayu
        ms-vscode-remote.vscode-remote-extensionpack
        tamasfe.even-better-toml
        github.copilot-chat
        github.copilot
        plugins.ibecker.treefmt-vscode
      ];
      # ++ [ pkgs.vscode-marketplace.plugins.ibecker.treefmt-vscode ];
    userSettings = {
      "files.autoSave" = "afterDelay";
      "editor.formatOnSave" = true;
      "editor.defaultFormatter" = "ibecker.treefmt-vscode";
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
      "workbench.startupEditor" = "none";
    };
  };
}
