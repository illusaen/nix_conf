{
  USER,
  HOME,
  CONFIG_DIR,
  ...
}:
let
  HM_MODULE_DIR = "${HOME}/${CONFIG_DIR}/home-manager/modules";
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."${USER}" = import ./user.nix;
    extraSpecialArgs = { inherit USER HOME HM_MODULE_DIR; };
  };
}
