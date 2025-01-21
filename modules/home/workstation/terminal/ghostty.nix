{
  lib,
  hozen,
  osConfig,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (hozen) color;
  inherit (osConfig.ooknet.host) admin;
  inherit (osConfig.ooknet.appearance.fonts) monospace;
  inherit (osConfig.ooknet.workstation) default;

  cfg = osConfig.ooknet.workstation.programs.ghostty;
in {
  config = mkMerge [
    (mkIf (cfg.enable || default.terminal == "ghostty") {
      programs.ghostty = {
        enable = true;
        enableFishIntegration = admin.shell == "fish";
        settings = {
          # defined below
          theme = "hozen";

          # font config
          font-size = monospace.size;
          font-family = monospace.family;
          font-family-bold = "${monospace.family} Bold";
          font-family-italic = "${monospace.family} Italic";
          font-family-bold-italic = "${monospace.family} Bold Italic";

          # padding
          window-padding-x = 9;
          window-padding-y = 9;

          # box drawing glyph thickness
          adjust-box-thickness = -10; # why where they so thick?

          # disable the window decorations
          gtk-titlebar = false;
          window-decoration = false;

          # disable close terminal prompt
          confirm-close-surface = false;
        };
        themes.hozen = {
          background = "${color.base00}";
          foreground = "${color.base05}";
          palette = [
            "0=#${color.base00}" # black
            "1=#${color.base08}" # red
            "2=#${color.base0B}" # green
            "3=#${color.base0A}" # yellow
            "4=#${color.base0D}" # blue
            "5=#${color.base0E}" # magenta
            "6=#${color.base0C}" # cyan
            "7=#${color.base05}" # white
            "8=#${color.base03}" # bright black
            "9=#${color.base08}" # bright red
            "10=#${color.base0B}" # bright green
            "11=#${color.base0A}" # bright yellow
            "12=#${color.base0D}" # bright blue
            "13=#${color.base0E}" # bright magenta
            "14=#${color.base0C}" # bright cyan
            "15=#${color.base07}" # bright white
          ];
        };
      };
    })
    (mkIf (default.terminal == "ghostty") {
      home.sessionVariables = {
        TERMINAL = "ghostty";
        TERM = "ghostty";
      };
      ooknet.binds = {
        terminal = "ghostty";
        terminalLaunch = "ghostty -e";
        terminalDropdown = "ghostty --title=dropdown";
        btop = mkIf config.programs.btop.enable "ghostty --title=BTOP -e btop";
      };
    })
  ];
}
