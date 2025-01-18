{
  inputs,
  lib,
  hozen,
  ...
}: {
  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage qt6Packages;

    projectPlus = {
      fpp-config = callPackage ./project-plus/fpp-config.nix {};
      fpp-launcher = callPackage ./project-plus/fpp-launcher.nix {};
      fpp-sd = callPackage ./project-plus/fpp-sd.nix {};
      package = qt6Packages.callPackage ./project-plus {
        inherit (projectPlus) fpp-config;
      };
    };
  in {
    packages = {
      repomix = callPackage ./repomix {};
      live-buds-cli = callPackage ./live-buds-cli {};
      website = callPackage ./website {};
      caddy-with-cloudflare = callPackage ./caddy-with-cloudflare {};
      wii-u-gc-adapter = callPackage ./wii-u-gc-adapter {};
      ook-vim = callPackage ./ook-vim {inherit inputs pkgs lib hozen;};

      inherit (projectPlus) fpp-config fpp-launcher fpp-sd;
      project-plus = projectPlus.package;
      spotify-player = pkgs.spotify-player.override {
        withImage = false;
        withSixel = false;
      };
    };
  };
}
