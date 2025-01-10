{
  USER,
  lib,
  config,
  HM_MODULE_DIR,
  ...
}:

let
  inherit (lib) types;
in
{
  options.programs = {
    _wezterm = {
      enable = lib.mkEnableOption "Whether to enable the WezTerm terminal emulator.";
      copyToConfig = lib.mkOption {
        description = "Copy `wezterm.lua` to the user's config directory.";
        type = types.bool;
        default = true;
      };

    };
  };

  config =
    let
      _wezterm-cfg = lib.mkIf config.programs._wezterm.enable {
        system.activationScripts.postActivation.text = ''
          source="${HM_MODULE_DIR}/wezterm/wezterm.lua"
          destination="/mnt/c/Users/${USER}/.config/wezterm/wezterm.lua"
          if [ ! -f "$source" ]; then
            echo "$source does not exist."
          fi
          if [ -e "$destination" ]; then
            rm "$destination"
          fi
          cp "$source" "$destination"
        '';
      };
    in
    lib.mkMerge [ _wezterm-cfg ];
}
