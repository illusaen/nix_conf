{
  pkgs,
  ...
}:

{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      cd = "j";
      cdd = "builtin cd";
      ga = "git add";
      gal = "git add .";
      gg = "git pull";
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
      rmr = "rm -r";
      lg = "lazygit";
      cat = "bat";
      l = "eza";
      ll = "eza -al";
      lt = "eza --tree --git-ignore --all";
      ncn = "code $NIX_CONF";
      ncg = "nix-collect-garbage";
      create_dev_shell_languages = {
        regex = "^dev[a-zA-Z]+$";
        function = "create_development_shell";
      };
    };

    functions = {
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

      create_development_shell = ''
        set --local available_templates (get_directory_names "$NIX_CONF/templates")
        set --local regex "^dev(?<language>$available_templates)\$"
        if string match -rq $regex $argv
            echo "$HOME/.local/bin/scripts/devshell $language"
        else
            echo "$argv template doesn't exist yet." >/dev/stdout
        end
      '';

      get_directory_names = ''
        set -l dir $argv[1]
        if not test -d $dir
            return
        end

        set -l result ""
        for x in $dir/*
            if test -d $x
                set result "$result|"(basename $x)
            end
        end

        if test -n "$result"
            echo (string trim -c "|" $result)
        end
      '';

      mkd = ''
        if test -n "$argv"
          mkdir -p $argv
          cd $argv
        else
          echo "Usage: mkd <directory>"
        end
      '';
    };

    plugins = [
      {
        name = "fishplugin-fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "fishplugin-autols.fish";
        src = pkgs.fetchFromGitHub {
          owner = "kpbaks";
          repo = "autols.fish";
          rev = "fe2693e80558550e0d995856332b280eb86fde19";
          sha256 = "EPgvY8gozMzai0qeDH2dvB4tVvzVqfEtPewgXH6SPGs=";
        };
      }
    ];
  };
}
