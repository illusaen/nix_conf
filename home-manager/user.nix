{
  isDarwin,
  USER,
  HOME,
  ...
}:

let
  darwin-file = ./darwin-modules.nix;

  shared-modules = [
    ./modules/helix/helix.nix
    ./modules/fish/fish.nix
    ./modules/starship/starship.nix
    ./modules/dev.nix
    ./modules/cli.nix
  ];
in
{
  imports = shared-modules ++ (if isDarwin then [ darwin-file ] else [ ]);

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

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
