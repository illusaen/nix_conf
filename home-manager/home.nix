{
  pkgs,
  USER,
  HOME,
  HOST,
  CONFIG_DIR,
  ...
}:
let
  HM_MODULE_DIR = "${HOME}/${CONFIG_DIR}/home-manager/modules";
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${USER}" = import ./user.nix;
    extraSpecialArgs = {
      inherit
        USER
        HOME
        HOST
        HM_MODULE_DIR
        isDarwin
        ;
    };
  };
}
