{
  pkgs,
  USER,
  HOME,
  HOST,
  HM_MODULE_DIR,
  ...
}:
let
  IS_DARWIN = pkgs.stdenv.hostPlatform.isDarwin;
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
        IS_DARWIN
        ;
    };
  };
}
