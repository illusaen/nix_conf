{
  pkgs,
  USER,
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
        HM_MODULE_DIR
        IS_DARWIN
        ;
    };
  };
}
