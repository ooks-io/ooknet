{
  lib,
  ook,
  osConfig,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  inherit (ook) color;
  inherit (osConfig.ooknet.host) admin;
  inherit (osConfig.ooknet.appearance.fonts) monospace;
  inherit (osConfig.ooknet.workstation) default;

  # getShader = shader: "${self'.packages.ghostty-shaders}/${shader}.glsl";

  cfg = osConfig.ooknet.workstation.programs.ghostty;
in {
  config = mkMerge [
    (mkIf (cfg.enable || default.terminal == "ghostty") {
      programs.ghostty = {
        enable = true;
        package =
          if isDarwin
          then null
          else pkgs.ghostty;
        enableFishIntegration = admin.shell == "fish";
        clearDefaultKeybinds = true;
        settings = {
          # defined below
          theme = "hozen";

          # font config
          font-size = monospace.size;
          font-family = monospace.family;

          # padding
          window-padding-x = 9;
          window-padding-y = 9;

          # box drawing glyph thickness
          adjust-box-thickness = -10; # why where they so thick?

          # ghostty >=1.2.3 counts each hi-res wheel event (G502: ~8/notch) as a
          # full click, see ghostty-org/ghostty#9966. discrete = mouse wheel,
          # precision left at default so touchpad hosts are unaffected
          mouse-scroll-multiplier = "precision:1,discrete:0.15";

          # disable the decorations
          gtk-titlebar = false;
          window-decoration = false;
          resize-overlay = "never";

          gtk-single-instance = true;

          # disable close terminal prompt
          confirm-close-surface = false;

          keybind =
            [
              "ctrl+equal=increase_font_size:1"
              "ctrl+minus=decrease_font_size:1"
              "ctrl+zero=reset_font_size"
              "ctrl+shift+v=paste_from_clipboard"
              "ctrl+shift+c=copy_to_clipboard"
            ]
            # clearDefaultKeybinds also wipes ghostty's default cmd-q quit;
            # restore it so cmd-q quits ghostty like every other macos app
            ++ lib.optional isDarwin "super+q=quit";
          macos-option-as-alt = isDarwin;
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
