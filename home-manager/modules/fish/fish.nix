{
  pkgs,
  HOST,
  USER,
  config,
  ...
}:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  wslCommands = ''fish_add_path --append "/mnt/c/Users/${USER}/AppData/Local/Microsoft/WinGet/Packages/equalsraf.win32yank_Microsoft.Winget.Source_8wekyb3d8bbwe"'';
in
{
  programs.fish = {
    interactiveShellInit =
      ''
        fish_add_path --append "$HOME/.local/bin"
      ''
      + (if !isDarwin then wslCommands else "");

    enable = true;

    shellAbbrs = {
      cd = "j";
      cdd = "builtin cd";
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
      rmr = "rm -r";
      lg = "lazygit";
      cat = "bat";
      l = "eza";
      ll = "eza -al";
      lt = "eza --tree --git-ignore --all";
      ncn = "code $NIX_CONF";
      nrn =
        if isDarwin then
          "darwin-rebuild switch --flake $NIX_CONF"
        else
          "sudo nixos-rebuild switch --flake $NIX_CONF#${HOST}";
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
  xdg.configFile."fish/functions/get_directory_names.fish".source =
    config.lib.file.mkOutOfStoreSymlink ./get_directory_names.fish;
  xdg.configFile."fish/functions/create_development_shell.fish".source =
    config.lib.file.mkOutOfStoreSymlink ./create_development_shell.fish;
}
