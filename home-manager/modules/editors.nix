{ pkgs, lib, ... }:

let
  plugins = (import ./vscode-custom-plugins.nix) {
    pkgs = pkgs;
    lib = lib;
  };
in
{
  programs = {
    helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "gruvbox_dark_hard";
        editor = {
          rulers = [ 120 ];
          color-modes = true;
          text-width = 120;
          indent-guides.render = true;
          statusline.center = [ "mode" ];
          whitespace.render.tab = "all";
          end-of-line-diagnostics = "hint";
          inline-diagnostics.cursor-line = "warning";
          inline-diagnostics.other-lines = "info";
          auto-save = {
            focus-lost = true;
            after-delay.enable = true;
          };
        };
        keys.insert = {
          j.k = "normal_mode";
          "C-s" = [
            "normal_mode"
            ":w"
            "insert_mode"
          ];
        };
        keys.normal = {
          "C-s" = ":w";
          g.a = "code_action";
          "ret" = [
            "open_below"
            "normal_mode"
          ];
        };
      };
      languages = {
        language-server.rust-analyzer = {
          config = {
            checkOnSave.command = "clippy";
            cargo.allFeatures = true;
          };
        };
        language = [
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "python";
            auto-format = true;
          }
        ];
      };
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
        "workbench.colorTheme" = "Monokai Pro";
        "workbench.startupEditor" = "none";
        "svelte.enable-ts-plugin" = true;
        "files.associations" = {
          "*.css" = "tailwindcss";
        };
        "editor.quickSuggestions" = {
          "strings" = "on";
        };
        "git.autofetch" = true;
        "github.copilot.chat.completionContext.typescript.mode" = "on";
        "github.copilot.chat.temporalContext.enabled" = true;
        "github.copilot.chat.generateTests.codeLens" = true;
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
        plugins.ibecker.treefmt-vscode
        plugins.oven.bun-vscode
        plugins.monokai.theme-monokai-pro-vscode
      ];
    };
  };
}
