{ pkgs, ... }:

{
  home.packages = with pkgs; [
    raycast
    google-chrome
  ];

  programs = {
    fish.shellAbbrs = {
      nrn = "cd $NIX_CONF; git add .; darwin-rebuild switch --flake $NIX_CONF; cd -";
    };
    wezterm.enable = true;
    vscode.package = pkgs.vscode;
  };
}
