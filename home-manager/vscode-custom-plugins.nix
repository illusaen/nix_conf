{ pkgs, lib }:

let
  inherit (pkgs.stdenv) isDarwin isAarch32 isAarch64;
  vscode-utils = pkgs.vscode-utils;
in
  lib.attrsets.optionalAttrs (isDarwin && (isAarch32 || isAarch64)) {
    "ibecker"."treefmt-vscode" = vscode-utils.extensionFromVscodeMarketplace {
      name = "treefmt-vscode";
      publisher = "ibecker";
      version = "2.1.1";
      sha256 = "1pzz857yzzisli1hqi38rnaa1wryh8d94l22p02dzfz3g0kxplb1";
      arch = "darwin-arm64";
    };
  }

