{
  config,
  IS_DARWIN,
  USER,
  HOME,
  HM_MODULE_DIR,
  ...
}:

let
  darwin-file = ./darwin-modules.nix;
  wsl-file = ./wsl-modules.nix;

  shared-modules = [
    ./modules/helix/helix.nix
    ./modules/fish/fish.nix
    ./modules/starship/starship.nix
    ./modules/lunarvim/lunarvim.nix
    ./modules/dev.nix
  ];
in
{
  imports = shared-modules ++ (if IS_DARWIN then [ darwin-file ] else [ wsl-file ]);

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
    sessionVariables = {
      EDITOR = "hx";
      NIX_CONF = "$HOME/nix_conf";
      fzf_preview_dir_cmd = "eza --all --color=always";
    };
  };

  home.file.".local/bin/scripts" = {
    source = config.lib.file.mkOutOfStoreSymlink "${HM_MODULE_DIR}/../scripts";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
