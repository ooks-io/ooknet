{
  pkgs,
  lib,
  osConfig,
  self',
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) attrValues;

  cfg = osConfig.ooknet.console.tools.utils;
in {
  config = mkIf cfg.enable {
    home.packages = attrValues {
      inherit
        (pkgs)
        bc # Calculator
        
        # file utility
        
        duf
        du-dust
        fd
        ripgrep
        # archive
        
        zip
        unzip
        unrar
        # file transfer
        
        rsync
        wget
        httpie # Better curl
        
        # resource manager
        
        powertop
        #shell scripting
        
        gum
        # audio ctrl
        
        pamixer
        diffsitter # Better diff
        jq # JSON pretty printer and manipulator
        tldr # Community maintained help pages
        progress
        killall
        acpi
        # Notifications
        
        libnotify
        # Nix tooling
        
        alejandra
        ;

      #AI
      inherit (self'.packages) repopack;
    };
  };
}
