{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Wendy Chen";
    userEmail = "jaewchen@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}