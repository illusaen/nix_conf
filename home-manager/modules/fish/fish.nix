{ pkgs, ... }:

{
  home.sessionVariables = {
    fzf_preview_dir_cmd = "eza --all --color=always";
    NIX_CONF = "$HOME/nix_conf";
  };

  programs.fish = {
    enable = true;

    shellAbbrs = {
      ga = "git add";
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
      ncn = "code $NIX_CONF";
      nrn = "darwin-rebuild switch --flake $NIX_CONF";
      ncg = "nix-collect-garbage";
      devnode = "nix flake init --template $NIX_CONF#node";
      devrust = "nix flake init --template $NIX_CONF#rust";
      grl = "gh repo list | fzf";
    };

    functions = {
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
