{
  config,
  osConfig,
  lib,
  ...
}: let
  inherit (osConfig.ooknet.appearance) colorscheme fonts;
  inherit (colorscheme) palette;
  inherit (config.ooknet) desktop;
  inherit (lib) mkMerge mkIf;
  cfg = config.ooknet.terminal.foot;
in {
  config = mkMerge [
    (mkIf (cfg.enable || desktop.terminal == "foot") {
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
            foreground = "${palette.base05}";
            background = "${palette.base00}";
            regular0 = "${palette.base00}"; # black
            regular1 = "${palette.red}"; # red
            regular2 = "${palette.green}"; # green
            regular3 = "${palette.yellow}"; # yellow
            regular4 = "${palette.blue}"; # blue
            regular5 = "${palette.purple}"; # magenta
            regular6 = "${palette.cyan}"; # cyan
            regular7 = "${palette.base05}"; # white
            bright0 = "${palette.base03}"; # bright black
            bright1 = "${palette.bright-red}"; # bright red
            bright2 = "${palette.bright-green}"; # bright green
            bright3 = "${palette.bright-yellow}"; # bright yellow
            bright4 = "${palette.bright-blue}"; # bright blue
            bright5 = "${palette.bright-purple}"; # bright magenta
            bright6 = "${palette.bright-cyan}"; # bright cyan
            bright7 = "${palette.base07}"; # bright white
            "16" = "${palette.base09}";
            "17" = "${palette.base0F}";
            "18" = "${palette.base01}";
            "19" = "${palette.base02}";
            "20" = "${palette.base04}";
            "21" = "${palette.base06}";
          };
        };
      };
    })

    (mkIf (desktop.terminal == "foot") {
      home.sessionVariables = {
        TERMINAL = "foot";
        TERM = "foot";
      };
      ooknet.binds.terminal = "foot";
      ooknet.binds.terminalLaunch = "foot";
    })
  ];
}
