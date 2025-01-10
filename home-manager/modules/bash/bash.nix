{
  config,
  ...
}:

let
  reload = ''
    source $HOME/.config/bash/devshell.bash
    source $HOME/.config/bash/git.bash
  '';
in
{
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  programs.bash = {
    enable = true;

    initExtra = reload;

    shellAliases = {
      cd = "j";
      cdd = "builtin cd";
      ga = "git add";
      gal = "git add .";
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
      ncg = "nix-collect-garbage";
      dev = "create_development_shell";
      reload = reload;
      ns = "sudo netstat -plten | grep \"$1\" | awk -F' ' '{print $9}' | awk -F/ '{print $1}' | xargs -r kill";
    };
  };

  xdg.configFile."bash/devshell.bash".source = config.lib.file.mkOutOfStoreSymlink ./devshell.bash;
  xdg.configFile."bash/git.bash".source = config.lib.file.mkOutOfStoreSymlink ./git.bash;
}
