# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "dev";
    homeDirectory = "/home/dev";
  };

  home.sessionVariables = {
    EDITOR = "hx";
    FZF_PREVIEW_DIR_CMD = "eza --all --color=always";
  };
  
  home.packages = with pkgs; [ helix fish git bat eza fzf zoxide starship ];

  programs.home-manager.enable = true;

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd j" ];
  };

  programs.fzf.enable = true;
  
  programs.fish = {
    enable = true;

    shellAbbrs = {
      hmconfig = "$EDITOR ~/nix_conf/home-manager/home.nix";
      gd = "git diff";
      gco = "git checkout";
      gcl = "git clone";
      gst = "git status";
      gga = { setCursor = true; function = "git_add_commit_push"; };
      ggcl = { setCursor = true; function = "git_clone_own_repo"; };
      cat = "bat";
      l = "eza";
      ll = "eza -al";
      lt = "eza --tree --git-ignore --all";
      nrn = "sudo nixos-rebuild switch --flake .#wsl-nixos";
      ncg = "nix-collect-garbage";
    };

    functions = {
      hmreload = ''
          set -l current_directory (pwd)
          cd ~/nix_conf
          home-manager switch --flake .#dev@wsl-nixos
          cd $current_directory
      '';

      nixreload = ''
        set -l current_directory (pwd)
        cd ~/nix_conf
        sudo nixos-rebuild switch --flake .#wsl-nixos --impure
        cd $current_directory
      '';

      git_add_commit_push = ''
          echo 'git add .;git commit -m "%";git push'
      '';

      git_clone_own_repo = ''
          echo "git clone git@github.com:illusaen/%.git"
      '';
    };
    
    plugins = with pkgs.fishPlugins; [
      { name = "fishplugin-fzf-unstable"; src = pkgs.fishPlugins.fzf.src; }
      { name = "fishplugin-colored-man-pages-unstable"; src = pkgs.fishPlugins.colored-man-pages.src; }
      { name = "fishplugin-async-prompt"; src = pkgs.fishPlugins.async-prompt; }
    ];
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
  
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };
  
  programs.git = {
    enable = true;
    userName = "Wendy Chen";
    userEmail = "jaewchen@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  home.file = {
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix_conf/home-manager/starship.toml";
    ".config/helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix_conf/home-manager/helix-config.toml";
    ".config/helix/languages.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix_conf/home-manager/helix-languages.toml";
    ".config/fish/conf.d/autols.fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix_conf/home-manager/autols.fish";
    #".config/fish/conf.d/fzf.fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix_conf/home-manager/fzf.fish";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
