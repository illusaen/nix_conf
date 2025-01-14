{
  pkgs,
  lib,
  config,
  HM_MODULE_DIR,
  ...
}:

let
  plugins = (import ../vscode-custom-plugins.nix) {
    pkgs = pkgs;
    lib = lib;
  };
in
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
    vscode = {
      enable = true;
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
        "svelte.enable-ts-plugin" = true;
        "files.associations" = {
          "*.css" = "tailwindcss";
        };
        "editor.quickSuggestions" = {
          "strings" = "on";
        };
      };
      extensions = with pkgs.vscode-extensions; [
        dbaeumer.vscode-eslint
        jnoortheen.nix-ide
        mkhl.direnv
        svelte.svelte-vscode
        teabyii.ayu
        tamasfe.even-better-toml
        github.copilot-chat
        github.copilot
        denoland.vscode-deno
        dbaeumer.vscode-eslint
        golang.go
        tauri-apps.tauri-vscode
        bradlc.vscode-tailwindcss
        rust-lang.rust-analyzer
        # plugins.ibecker.treefmt-vscode
      ];
    };
  };

  xdg.configFile."wezterm/wezterm.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${HM_MODULE_DIR}/wezterm/wezterm.lua";
}
