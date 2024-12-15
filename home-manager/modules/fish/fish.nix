{ pkgs, HOST, ... }:

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
      git_clone_repo = {
        setCursor = true;
        function = "git_clone_own_repo";
        regex = "^g(gc|r)l$";
      };
      cat = "bat";
      l = "eza";
      ll = "eza -al";
      lt = "eza --tree --git-ignore --all";
      ncn = "code $NIX_CONF";
      nrn =
        if pkgs.stdenv.hostPlatform.isDarwin then
          "darwin-rebuild switch --flake $NIX_CONF"
        else
          "sudo nixos-rebuild switch --flake $NIX_CONF#${HOST}";
      ncg = "nix-collect-garbage";
      create_dev_shell_languages = {
        regex = "^dev[a-zA-Z]+";
        function = "create_development_shell";
      };
    };

    functions = {
      create_development_shell = ''
        if string match -rq '^dev(?<language>node|rust)$' $argv
          echo "$HOME/.local/bin/scripts/devshell.sh $language"
        else
          echo "$language template doesn't exist yet." > /dev/stdout
        end
      '';

      git_add_commit_push = ''
        echo 'git add .;git commit -m "%";git push'
      '';

      git_clone_own_repo = ''
        set --local base_url 'git@github.com:illusaen/'
        set --local default_result git clone $base_url'%.git'
        switch $argv
          case ggcl
            echo $default_result
          case grl
            set --local repo_name (gh repo list | fzf)
            if test -n "$repo_name" && string match -rq '^.+\/(?<repo>\S+).+$' $repo_name
              echo git clone $base_url$repo'.git'
            end
        end
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
