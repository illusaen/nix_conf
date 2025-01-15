{ pkgs, lib }:

let
  inherit (pkgs.stdenv)
    isDarwin
    isLinux
    isi686
    isx86_64
    isAarch32
    isAarch64
    ;
  vscode-utils = pkgs.vscode-utils;
  merge = lib.attrsets.recursiveUpdate;
in
merge
  (merge
    (merge
      (merge
        {
          "oven"."bun-vscode" = vscode-utils.extensionFromVscodeMarketplace {
            name = "bun-vscode";
            publisher = "oven";
            version = "0.0.26";
            sha256 = "13ml1zk8g5g56c74acq9xrhndyj1s1k1ayadlgv9hn1b18l28lwj";
          };
        }
        (
          lib.attrsets.optionalAttrs (isLinux && (isi686 || isx86_64)) {
            "ibecker"."treefmt-vscode" = vscode-utils.extensionFromVscodeMarketplace {
              name = "treefmt-vscode";
              publisher = "ibecker";
              version = "2.1.1";
              sha256 = "1m95zy6pz6rawhv35xxh6cjfpy7j1bwv6p9pxqy5wk3qxg0r1gsj";
              arch = "linux-x64";
            };
          }
        )
      )
      (
        lib.attrsets.optionalAttrs (isLinux && (isAarch32 || isAarch64)) {
          "ibecker"."treefmt-vscode" = vscode-utils.extensionFromVscodeMarketplace {
            name = "treefmt-vscode";
            publisher = "ibecker";
            version = "2.1.1";
            sha256 = "05r3dflrzl692jqqzrkk712pvxgf52six5ppzda46z0kim22ikxx";
            arch = "linux-arm64";
          };
        }
      )
    )
    (
      lib.attrsets.optionalAttrs (isDarwin && (isi686 || isx86_64)) {
        "ibecker"."treefmt-vscode" = vscode-utils.extensionFromVscodeMarketplace {
          name = "treefmt-vscode";
          publisher = "ibecker";
          version = "2.1.1";
          sha256 = "1g8b1nwpk6va5j4jv4kh4cmnhl2l4n0w6brxrb02rma8zdbf2ya9";
          arch = "darwin-x64";
        };
      }
    )
  )
  (
    lib.attrsets.optionalAttrs (isDarwin && (isAarch32 || isAarch64)) {
      "ibecker"."treefmt-vscode" = vscode-utils.extensionFromVscodeMarketplace {
        name = "treefmt-vscode";
        publisher = "ibecker";
        version = "2.1.1";
        sha256 = "1pzz857yzzisli1hqi38rnaa1wryh8d94l22p02dzfz3g0kxplb1";
        arch = "darwin-arm64";
      };
    }
  )
