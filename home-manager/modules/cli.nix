{ ... }:

{
  programs = {
    bat.enable = true;
    fd.enable = true;
    ripgrep.enable = true;
    eza = {
      enable = true;
      icons = "auto";
      git = true;
    };
    fzf = {
      enable = true;
      enableFishIntegration = false;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd j" ];
    };
  };
}
