{
  USER,
  HM_MODULE_DIR,
  ...
}:

{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${USER}" = {
      imports = [
        ./modules/editors.nix
        ./modules/fish.nix
        ./modules/dev.nix
        ./modules/link.nix
      ];
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
      systemd.user.startServices = "sd-switch";
      home = {
        sessionVariables = {
          NIX_CONF = "$HOME/nix_conf";
          fzf_preview_dir_cmd = "eza --all --color=always";
        };
        sessionPath = [
          "$HOME/.local/bin/scripts"
        ];
      };
      programs.home-manager.enable = true;
      home.stateVersion = "24.11";
    };
    extraSpecialArgs = {
      inherit HM_MODULE_DIR;
    };
  };
}
