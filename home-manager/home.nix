{
  pkgs,
  USER,
  HOME,
  ...
}:

{
  imports = [
    ./modules/helix/helix.nix
    ./modules/fish/fish.nix
    ./modules/starship/starship.nix
    ./modules/bat.nix
    ./modules/eza.nix
    ./modules/git.nix
    ./modules/zoxide.nix
    ./modules/fzf.nix
    ./modules/direnv.nix
    ./modules/fd.nix
    ./modules/vscode.nix
    ./modules/nixlang.nix
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home = {
    username = USER;
    homeDirectory = HOME;
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  home.packages = with pkgs; [ raycast ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
