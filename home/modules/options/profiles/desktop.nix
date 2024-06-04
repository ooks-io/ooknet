{ lib, ... }:

let
  inherit (lib) mkOption types;
  inherit (types) enum nullOr listOf;
in

{
  options.ooknet.desktop = {

    environment = mkOption {
      type = nullOr (enum [ "hyprland" ]);
      default = "hyprland";
    };

    browser = mkOption {
      type = nullOr (enum [ "firefox" "brave" ]);
      default = null;
    };

    terminal = mkOption {
      type = nullOr (enum [ "foot" "kitty" "wezterm" ]);
      default = "foot";
    };

    fileManager = mkOption {
      type = nullOr (enum [ "nemo" ]);
      default = null;
    };

    notes = mkOption {
      type = nullOr (enum [ "obsidian" ]);
      default = null;
    };

    pdf = mkOption {
      type = nullOr (enum [ "zathura" ]);
      default = null;
    };

    discord = mkOption {
      type = nullOr (enum [ "vesktop" ]);
      default = null;
    };

    suites = mkOption {
      type = listOf (enum [ "gaming" "tools" "media" "creative" ]);
      default = [ ];
    };
  };
}
