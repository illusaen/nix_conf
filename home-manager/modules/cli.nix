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
    fzf.enable = true;
    zoxide = {
      enable = true;
      options = [ "--cmd j" ];
    };
  };
}
