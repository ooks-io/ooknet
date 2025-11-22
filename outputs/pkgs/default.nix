{
  inputs,
  lib,
  ook,
  ...
}: {
  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage qt6Packages writeTextFile;

    projectPlus = {
      fpp-config = callPackage ./project-plus/fpp-config.nix {};
      fpp-launcher = callPackage ./project-plus/fpp-launcher.nix {};
      fpp-sd = callPackage ./project-plus/fpp-sd.nix {};
      package = qt6Packages.callPackage ./project-plus {
        inherit (projectPlus) fpp-config;
      };
    };

    colorSchemeScss = writeTextFile {
      name = "colors.scss";
      text = ook.lib.color.export.toScss ook.color;
    };
  in {
    packages = {
      goki = callPackage ./goki {};
      wowup = callPackage ./wowup {};
      repomix = callPackage ./repomix {};
      live-buds-cli = callPackage ./live-buds-cli {};
      website = callPackage ./website {};
      #caddy-with-cloudflare = callPackage ./caddy-with-cloudflare {};
      wii-u-gc-adapter = callPackage ./wii-u-gc-adapter {};
      ghostty-shaders = callPackage ./ghostty-shaders {};
      ook-vim = callPackage ./ook-vim {inherit inputs pkgs lib ook;};

      inherit (projectPlus) fpp-config fpp-launcher fpp-sd;
      project-plus = projectPlus.package;

      # Color scheme exports
      color-scheme-scss = colorSchemeScss;

      claude-code = callPackage ./claude-code {};

      # disable spotify-player images due to jank with zellij
      # put it here so it gets cached
      spotify-player = pkgs.spotify-player.override {
        withImage = false;
        withSixel = false;
      };
    };
  };
}
