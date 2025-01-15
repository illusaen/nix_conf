{
  pkgs,
  lib,
  config,
  HM_MODULE_DIR,
  ...
}:

let
  user = config.home.username;
  home = config.home.homeDirectory;
  copyFile = ''
    shouldCopy = "$1"
    source="$2"
    destination="$3"
    if [ ! -f "$source" ] || [ -d "$source" ]; then
      echo "$source does not exist."
    fi
    if [ -f "$destination" ]; then
      rm "$destination"
    fi
    if [ -d "$destination" ]; then
      rm -rf "$destination"
    fi
    if [ "$shouldCopy" -eq 1 ]; then
      cp "$source" "$destination"
      echo "Copied $source to $destination"
    else
      ln -s "$source" "$destination"
      echo "Symlinked $source to $destination"
    fi
  '';
in
{
  programs = {
    git.extraConfig.core.sshCommand = "ssh.exe";
    fish.shellAbbrs = {
      nrn = "cd $NIX_CONF; git add .; sudo nixos-rebuild switch --flake $NIX_CONF; cd -";
    };
    vscode = {
      package = pkgs.openvscode-server;
      userSettings = {
        "security.allowedUNCHosts" = [ "rpi4.local" ];
      };
    };
  };

  home.activation.copyAndLinkFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    source="${HM_MODULE_DIR}/linked/wezterm.lua"
    destination="/mnt/c/Users/${user}/.config/wezterm/wezterm.lua"
    if [ ! -f "$source" ]; then
      echo "$source does not exist."
    fi
    if [ -f "$destination" ]; then
      rm "$destination"
    fi
    cp "$source" "$destination"
    echo "Copied $source to $destination"

    source="${home}/.config/OpenVSCode Server/User/settings.json" 
    destination="${home}/.vscode-server/data/Machine/settings.json"
    if [ ! -f "$source" ]; then
      echo "$source does not exist."
    fi
    if [ -f "$destination" ]; then
      rm "$destination"
    fi
    ln -s "$source" "$destination"
    echo "Symlinked $source to $destination"


    source="${home}/.openvscode-server/extensions"
    destination="${home}/.vscode-server/extensions"
    if [ -d "$source" ]; then
      echo "$source does not exist."
    fi
    if [ -d "$destination" ]; then
      rm -rf "$destination"
    fi
    ln -s "$source" "$destination"
    echo "Symlinked $source to $destination"
  '';
}
