{
  inputs,
  lib,
  hozen,
  ...
}: {
  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage qt6Packages;
  in {
    packages = {
      repopack = callPackage ./repopack {};
      live-buds-cli = callPackage ./live-buds-cli {};
      website = callPackage ./website {};
      caddy-with-cloudflare = callPackage ./caddy-with-cloudflare {};

      wii-u-gc-adapter = callPackage ./wii-u-gc-adapter {};

      ook-vim = callPackage ./ook-vim {inherit inputs pkgs lib hozen;};

      project-plus = let
        fpp-config = callPackage ./project-plus/fpp-config.nix {};
        fpp-launcher = callPackage ./project-plus/fpp-launcher.nix {};
        fpp-sd = callPackage ./project-plus/fpp-sd.nix {};
      in
        qt6Packages.callPackage ./project-plus {
          inherit fpp-launcher fpp-sd fpp-config;
        };
    };
  };
}
