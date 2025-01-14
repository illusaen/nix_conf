{ pkgs, ... }:

{
  home.packages = with pkgs; [
    raycast
    google-chrome
  ];

  programs.direnv.config.whitelist.prefix = [
    "~/Documents/projects"
  ];

  programs.fish.shellAbbrs = {
    nrn = "cd $NIX_CONF; git add .; darwin-rebuild switch --flake $NIX_CONF; cd -";
  };

  programs.wezterm.enable = true;
  programs.vscode.package = pkgs.vscode;
}
