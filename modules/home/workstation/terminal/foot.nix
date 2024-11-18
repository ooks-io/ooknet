{
  osConfig,
  lib,
  hozen,
  ...
}: let
  inherit (osConfig.ooknet.appearance) fonts;
  inherit (hozen) color;
  inherit (lib) mkMerge mkIf;
  inherit (osConfig.ooknet.workstation) default;
  cfg = osConfig.ooknet.workstation.programs.foot;
in {
  config = mkMerge [
    (mkIf (cfg.enable || default.terminal == "foot") {
      programs.foot = {
        enable = true;
        server.enable = true;
        settings = {
          main = {
            term = "xterm-256color";
            font = "${fonts.monospace.family}:pixelsize=18:antialias=true";
            font-bold = "${fonts.monospace.family}:style=Bold:pixelsize=18:antialias=true";
            font-italic = "${fonts.monospace.family}:style=Italic:pixelsize=18:antialias=true";
            font-bold-italic = "${fonts.monospace.family}:style=Bold Italic:pixelsize=18:antialias=true";
            dpi-aware = "yes";
            letter-spacing = "-1px";
            bold-text-in-bright = "palette-based";
            resize-delay-ms = "80";
            pad = "9x9 center";
            selection-target = "clipboard";
          };

          tweak = {
            sixel = "yes";
            font-monospace-warn = "no";
          };

          cursor = {
            style = "beam";
            blink = "yes";
          };

          colors = {
            alpha = 1.0;
            foreground = "${color.base05}";
            background = "${color.base00}";
            regular0 = "${color.base00}"; # black
            regular1 = "${color.base08}"; # red
            regular2 = "${color.base0B}"; # green
            regular3 = "${color.base0A}"; # yellow
            regular4 = "${color.base0D}"; # blue
            regular5 = "${color.base0E}"; # magenta
            regular6 = "${color.base0C}"; # cyan
            regular7 = "${color.base05}"; # white
            bright0 = "${color.base03}"; # bright black
            bright1 = "${color.base08}"; # bright red
            bright2 = "${color.base0B}"; # bright green
            bright3 = "${color.base0A}"; # bright yellow
            bright4 = "${color.base0D}"; # bright blue
            bright5 = "${color.base0E}"; # bright magenta
            bright6 = "${color.base0C}"; # bright cyan
            bright7 = "${color.base07}"; # bright white
            "16" = "${color.base09}";
            "17" = "${color.base0F}";
            "18" = "${color.base01}";
            "19" = "${color.base02}";
            "20" = "${color.base04}";
            "21" = "${color.base06}";
          };
        };
      };
    })

    (mkIf (default.terminal == "foot") {
      home.sessionVariables = {
        TERMINAL = "foot";
        TERM = "foot";
      };
      ooknet.binds.terminal = "foot";
      ooknet.binds.terminalLaunch = "foot";
    })
  ];
}
