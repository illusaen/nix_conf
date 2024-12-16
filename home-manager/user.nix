{
  config,
  isDarwin,
  USER,
  HOME,
  HM_MODULE_DIR,
  ...
}:

let
  darwin-file = ./darwin-modules.nix;

  shared-modules = [
    ./modules/helix/helix.nix
    ./modules/fish/fish.nix
    ./modules/starship/starship.nix
    ./modules/lunarvim/lunarvim.nix
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
    sessionVariables = {
      EDITOR = "hx";
      fzf_preview_dir_cmd = "eza --all --color=always";
      NIX_CONF = "$HOME/nix_conf";
    };
  };

  home.file.".local/bin/scripts" = {
    source = config.lib.file.mkOutOfStoreSymlink "${HM_MODULE_DIR}/../scripts";
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
