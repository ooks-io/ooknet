{
  inputs,
  lib,
  ook,
  ...
}: {
  perSystem = {pkgs, ...}: let
    inherit (pkgs) callPackage qt6Packages writeTextFile;

    # claude-desktop is unfree, our package set isnt; scope an unfree
    # nixpkgs to just it rather than flipping allowUnfree globally
    pkgsClaude = import inputs.nixpkgs {
      inherit (pkgs.stdenv.hostPlatform) system;
      config.allowUnfreePredicate = p: lib.getName p == "claude-desktop";
    };
    claudeDesktop = rec {
      node-pty = pkgsClaude.callPackage ./claude-desktop/node-pty.nix {};
      package = pkgsClaude.callPackage ./claude-desktop {inherit node-pty;};
      fhs = pkgsClaude.callPackage ./claude-desktop/fhs.nix {claude-desktop = package;};
    };

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
      curseforge = callPackage ./curseforge {};

      inherit (projectPlus) fpp-config fpp-launcher fpp-sd;
      project-plus = projectPlus.package;

      # Color scheme exports
      color-scheme-scss = colorSchemeScss;

      claude-code = callPackage ./claude-code {};

      claude-desktop = claudeDesktop.package;
      claude-desktop-fhs = claudeDesktop.fhs;

      # disabled temporarily - regex-syntax compile failure on current nixpkgs
      # spotify-player = pkgs.spotify-player.override {
      #   withImage = false;
      #   withSixel = false;
      # };
    };
  };
}
