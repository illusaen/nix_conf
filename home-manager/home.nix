{ inputs, config, vars, ... }: 

{
  _module.args.vars = vars;
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
    username = vars.username;
    homeDirectory = vars.home;
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
