{
  pkgs,
  USER,
  HOME,
  HOST,
  HM_MODULE_DIR,
  ...
}:
let
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
