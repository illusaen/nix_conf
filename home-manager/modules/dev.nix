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
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
      config = {
        hide_env_diff = true;
        whitelist.prefix = [ "~/projects" ];
      };
    };
    eza = {
      enable = true;
      icons = "auto";
      git = true;
    };
    fd.enable = true;
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
    gh.enable = true;
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
    lazygit.enable = true;
    ripgrep.enable = true;
    zellij = {
      enable = true;
      settings = {
        default_shell = "bash";
        copy_on_select = true;
        theme = "ayu_mirage";
      };
    };
    zoxide = {
      enable = true;
      options = [ "--cmd j" ];
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = true;
        palette = "dracula";
        palettes.dracula = {
          foreground = "#F8F8F2";
          current_line = "#44475A";
          primary = "#1A1F29";
          box = "#44475A";
          blue = "#80bfff";
          green = "#d5ff80";
          orange = "#ffd173";
          pink = "#f28779";
          purple = "#dfbfff";
          red = "#FF5555";
          yellow = "#73d0ff";
        };
        format = lib.concatStrings [
          "[╭](fg:current_line)"
          "$directory"
          "$git_branch"
          "$git_status"
          "$fill"
          "$direnv"
          "$nodejs"
          "$python"
          "$c"
          "$cmd_duration"
          "$time"
          "$line_break"
          "$character"
        ];
        c = {
          format = "[─](fg:current_line)[](fg:blue)[$symbol](fg:primary bg:blue)[](fg:blue bg:box)[ $version](fg:foreground bg:box)[](fg:box)";
          symbol = " ";
        };
        character = {
          format = "[╰─$symbol](fg:current_line) ";
          success_symbol = "[λ](fg:bold white)";
          error_symbol = "[×](fg:bold red)";
        };
        cmd_duration = {
          min_time = 500;
          format = "[─](fg:current_line)[](fg:orange)[ ](fg:primary bg:orange)[](fg:orange bg:box)[ $duration ](fg:foreground bg:box)[](fg:box)";
        };
        directory = {
          format = "[─](fg:current_line)[](fg:pink)[󰷏 ](fg:primary bg:pink)[](fg:pink bg:box)[ $read_only$truncation_symbol$path](fg:foreground bg:box)[](fg:box)";
          home_symbol = " ~/";
          truncation_symbol = " ";
          truncation_length = 3;
          read_only = "󱧵 ";
          read_only_style = "";
        };
        direnv = {
          disabled = false;
          format = "[─](fg:current_line)[](fg:yellow)[$symbol](fg:primary bg:yellow)[](fg:yellow bg:box)[ $allowed ](fg:foreground bg:box)[](fg:box)";
          symbol = " ";
          not_allowed_msg = "";
          allowed_msg = "󰄭";
        };
        fill = {
          symbol = "─";
          style = "fg:current_line";
        };
        git_branch = {
          format = "[─](fg:current_line)[](fg:green)[$symbol](fg:primary bg:green)[](fg:green bg:box)[ $branch](fg:foreground bg:box)";
          symbol = " ";
        };
        git_status = {
          ignore_submodules = true;
          format = "[ $all_status](fg:foreground bg:box)[](fg:box)";
        };
        nodejs = {
          disabled = false;
          format = "[─](fg:current_line)[](fg:green)[$symbol](fg:primary bg:green)[](fg:green bg:box)[ $version](fg:foreground bg:box)[](fg:box)";
          symbol = "󰎙 ";
        };
        python = {
          format = "[─](fg:current_line)[](fg:green)[$symbol](fg:primary bg:green)[](fg:green bg:box)[ $version (\($virtualenv\))](fg:foreground bg:box)[](fg:box)";
          symbol = " ";
        };
        time = {
          disabled = false;
          format = "[─](fg:current_line)[](fg:purple)[󰦖 ](fg:primary bg:purple)[](fg:purple bg:box)[ $time](fg:foreground bg:box)[](fg:box)";
          time_format = "%H:%M";
        };
      };
    };
  };
}
