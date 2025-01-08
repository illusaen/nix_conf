{
  pkgs,
  HOST,
  USER,
  config,
  ...
}:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  wslPath = ''fish_add_path --append "/mnt/c/Users/${USER}/AppData/Local/Microsoft/WinGet/Packages/equalsraf.win32yank_Microsoft.Winget.Source_8wekyb3d8bbwe"'';
in
{
  home.sessionPath = [
    "$HOME/.local/bin"
  ] ++ (if !isDarwin then [ wslPath ] else [ ]);

  programs.bash = {
    enable = true;

    initExtra = ''
      source $HOME/.config/bash/devshell.bash
      source $HOME/.config/bash/git.bash
    '';

    shellAliases = {
      cd = "j";
      cdd = "builtin cd";
      ga = "git add";
      gd = "git diff";
      gco = "git checkout";
      gcl = "git clone";
      gst = "git status";
      gl = "git pull";
      glog = "git log --ext-diff";
      gs = "git show --ext-diff";
      gga = "git_add_commit_push ";
      ggcl = "git_clone_own_repo ";
      grl = "git_clone_own_repo ";
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
      dev = "create_development_shell";
    };
  };

  xdg.configFile."bash/devshell.bash".source = config.lib.file.mkOutOfStoreSymlink ./devshell.bash;
  xdg.configFile."bash/git.bash".source = config.lib.file.mkOutOfStoreSymlink ./git.bash;
}
