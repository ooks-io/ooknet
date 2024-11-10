{lib, ...}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) nullOr enum listOf;
in {
  options.ooknet.workstation = {
    theme = mkOption {
      type = nullOr (enum ["minimal"]);
      default = null;
    };
    profiles = mkOption {
      type = listOf (enum ["gaming" "communication" "productivity" "creative" "media" "virtualization"]);
      default = [];
    };
    environment = mkOption {
      type = nullOr (enum ["hyprland"]);
      default = "hyprland";
    };
    default = {
      browser = mkOption {
        type = nullOr (enum ["firefox"]);
        default = "firefox";
      };
      terminal = mkOption {
        type = enum ["foot"];
        default = "foot";
      };
    };
    programs = {
      firefox.enable = mkEnableOption "";
      foot.enable = mkEnableOption "";
    };
  };
}
