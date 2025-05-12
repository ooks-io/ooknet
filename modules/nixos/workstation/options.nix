{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) nullOr enum listOf;
  inherit (pkgs.stdenv) isDarwin;
  cfg = config.ooknet.workstation;
in {
  options.ooknet.workstation = {
    theme = mkOption {
      type = nullOr (enum ["minimal" "hozen"]);
      default = null;
    };
    profiles = mkOption {
      type = listOf (enum ["gaming" "communication" "productivity" "creative" "media" "virtualization" "infra"]);
      default = [];
    };
    environment = mkOption {
      type = nullOr (enum ["hyprland" "gnome" "aerospace"]);
      default = "hyprland";
    };
    default = {
      browser = mkOption {
        type = nullOr (enum ["firefox" "chromium" "zen"]);
        default = "firefox";
      };
      terminal = mkOption {
        type = enum ["foot" "ghostty"];
        default = "foot";
      };
    };
    programs = {
      firefox.enable = mkEnableOption "";
      chromium.enable = mkEnableOption "";
      foot.enable = mkEnableOption "";
      ghostty.enable = mkEnableOption "";
      ollama.enable = mkEnableOption "";
      zen.enable = mkEnableOption "";
    };
  };
  config.assertions = [
    {
      assertion = !(cfg.environment == "aerospace" && !isDarwin);
      message = "The aerospace environment is for nix-darwin only";
    }
  ];
}
