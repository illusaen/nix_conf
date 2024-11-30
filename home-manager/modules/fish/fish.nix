{ pkgs, vars, ... }:

{
  home.sessionVariables = {
    fzf_preview_dir_cmd = "eza --all --color=always";
  };

  programs.fish = {
    enable = true;

    shellAbbrs = {
      hcn = "$EDITOR ${vars.nix_conf}/home-manager/home.nix";
      gd = "git diff";
      gco = "git checkout";
      gcl = "git clone";
      gst = "git status";
      gl = "git log --ext-diff";
      gs = "git show --ext-diff";
      gga = {
        setCursor = true;
        function = "git_add_commit_push";
      };
      ggcl = {
        setCursor = true;
        function = "git_clone_own_repo";
      };
      cat = "bat";
      l = "eza";
      ll = "eza -al";
      lt = "eza --tree --git-ignore --all";
      ncn = "$EDITOR ${vars.nix_conf}/nixos/configuration.nix";
      ncg = "nix-collect-garbage";
    };

    functions = {
      nrn = ''
        set -l current_directory (pwd)
        cd ~/nix_conf
        sudo nixos-rebuild switch --flake .#wsl-nixos --impure
        cd $current_directory
      '';

      git_add_commit_push = ''
        echo 'git add .;git commit -m "%";git push'
      '';

      git_clone_own_repo = ''
        echo "git clone git@github.com:illusaen/%.git"
      '';
    };

    plugins = [
      {
        name = "fishplugin-fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "fishplugin-colored-man-pages-unstable";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
      {
        name = "fishplugin-async-prompt";
        src = pkgs.fishPlugins.async-prompt;
      }
    ];
  };

  xdg.configFile."fish/conf.d/autols.fish".source = ./autols.fish;
}
