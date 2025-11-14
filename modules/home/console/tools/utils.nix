{
  pkgs,
  lib,
  osConfig,
  self',
  ...
}: let
  inherit (lib) optionals mkIf;
  inherit (builtins) attrValues;
  inherit (pkgs.stdenv) isLinux isDarwin;
  cfg = osConfig.ooknet.console.tools.utils;

  # common packages for all platforms
  commonPackages = attrValues {
    inherit
      (pkgs)
      yt-dlp
      claude-code
      bc
      duf
      dust
      fd
      ripgrep
      zip
      unzip
      rsync
      wget
      httpie
      diffsitter
      jq
      tldr
      progress
      killall
      libnotify
      alejandra
      cachix
      gum
      nvd
      nix-output-monitor
      ;

    # AI tools
    inherit
      (self'.packages)
      repomix
      goki
      ;
  };

  # linux-specific packages
  linuxPackages = attrValues {
    inherit
      (pkgs)
      pamixer
      acpi
      powertop
      unrar
      ;
  };

  # darwin-specific packages, if needed
  darwinPackages =
    attrValues {
    };
in {
  config = mkIf cfg.enable {
    home.packages =
      commonPackages
      ++ (optionals isLinux linuxPackages)
      ++ (optionals isDarwin darwinPackages);
  };
}
