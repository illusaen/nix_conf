{
  lib,
  config,
  HOME,
  ...
}:

let
  inherit (lib) types;
in
{
  options.programs = {
    _vscode = {
      enable = lib.mkEnableOption "Whether to enable the VSCode remote server.";
      copyToConfig = lib.mkOption {
        description = "Symlink vscode extensions and settings to .vscode-server.";
        type = types.bool;
        default = true;
      };

    };
  };

  config =
    let
      _vscode-cfg = lib.mkIf config.programs._vscode.enable {
        system.activationScripts.postActivation.text = ''
          settingsSource="${HOME}/.config/OpenVSCode Server/User/settings.json"
          settingsDestination="${HOME}/.vscode-server/data/Machine/settings.json"
          if [ ! -f "$settingsSource" ]; then
            echo "$settingsSource does not exist."
          fi
          # if [ -e "$settingsDestination" ]; then
            rm "$settingsDestination"
          # fi
          ln -s "$settingsSource" "$settingsDestination"
          echo "Symlinked $settingsSource to $settingsDestination"
          extensionsSource="${HOME}/.openvscode-server/extensions"
          extensionsDestination="${HOME}/.vscode-server/extensions"
          if [ ! -f "$extensionsSource" ]; then
            echo "$extensionsSource does not exist."
          fi
          # if [ -e "$extensionsDestination" ]; then
            rm -rf "$extensionsDestination"
          # fi
          ln -s "$extensionsSource" "$extensionsDestination"
          echo "Symlinked $extensionsSource to $extensionsDestination"
        '';
      };
    in
    lib.mkMerge [ _vscode-cfg ];
}
