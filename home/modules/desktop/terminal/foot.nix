{ config, lib, ... }:

let
  inherit (config.colorscheme) palette;
  inherit (lib) mkMerge mkIf;
  fonts = config.ooknet.fonts;
  cfg = config.ooknet.terminal.foot;
  desktop = config.ooknet.desktop;
in

{
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
          regular1 = "${palette.base08}"; # red
          regular2 = "${palette.base0B}"; # green
          regular3 = "${palette.base0A}"; # yellow
          regular4 = "${palette.base0D}"; # blue
          regular5 = "${palette.base0E}"; # magenta
          regular6 = "${palette.base0C}"; # cyan
          regular7 = "${palette.base05}"; # white
          bright0 = "${palette.base03}"; # bright black
          bright1 = "${palette.base08}"; # bright red
          bright2 = "${palette.base0B}"; # bright green
          bright3 = "${palette.base0A}"; # bright yellow
          bright4 = "${palette.base0D}"; # bright blue
          bright5 = "${palette.base0E}"; # bright magenta
          bright6 = "${palette.base0C}"; # bright cyan
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
