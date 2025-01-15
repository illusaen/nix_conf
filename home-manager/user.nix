{
  IS_DARWIN,
  ...
}:

let
  darwin-file = ./darwin-modules.nix;
  wsl-file = ./wsl-modules.nix;

  shared-modules = [
    ./modules/editors.nix
    ./modules/fish.nix
    ./modules/dev.nix
    ./modules/link.nix
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
    sessionVariables = {
      EDITOR = "hx";
      NIX_CONF = "$HOME/nix_conf";
      fzf_preview_dir_cmd = "eza --all --color=always";
    };
    sessionPath = [
      "$HOME/.local/bin/scripts"
    ];
  };

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
