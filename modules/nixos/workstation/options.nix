{lib, ...}: let
  inherit (lib) mkEnableOption mkOption;
  inherit (lib.types) nullOr enum listOf;
in {
  options.ooknet.workstation = {
    theme = mkOption {
      type = nullOr (enum ["minimal" "hozen"]);
      default = null;
    };
    profiles = mkOption {
      type = listOf (enum ["gaming" "communication" "productivity" "creative" "media" "virtualization"]);
      default = [];
    };
    environment = mkOption {
      type = nullOr (enum ["hyprland" "gnome"]);
      default = "hyprland";
    };
    default = {
      browser = mkOption {
        type = nullOr (enum ["firefox" "chromium"]);
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
    };
  };
}
