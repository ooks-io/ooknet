{ config, lib, ... }:

let
  inherit (config.colorscheme) colors;
  cfg = config.homeModules.desktop.terminal.foot;
in

{
  config = lib.mkIf cfg.enable {
    home.sessionVariables = lib.mkIf cfg.default {
      TERMINAL = "foot";
      TERM = "foot";
    };
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          font = "${config.fontProfiles.monospace.family}:pixelsize=18:antialias=true";
          font-bold = "${config.fontProfiles.monospace.family}:style=Bold:pixelsize=18:antialias=true";
          font-italic = "${config.fontProfiles.monospace.family}:style=Italic:pixelsize=18:antialias=true";
          font-bold-italic = "${config.fontProfiles.monospace.family}:style=Bold Italic:pixelsize=18:antialias=true";
          dpi-aware = "yes";
          letter-spacing = "-1px";
          bold-text-in-bright = "palette-based";
          resize-delay-ms = "80";       
          pad = "9x9 center";
        };
        cursor = {
          style = "beam";
          blink = "yes";
        };
        colors = {
          alpha = 1.0;
          foreground = "${colors.base05}";
          background = "${colors.base00}";
          regular0 = "${colors.base00}"; # black
          regular1 = "${colors.base08}"; # red
          regular2 = "${colors.base0B}"; # green
          regular3 = "${colors.base0A}"; # yellow
          regular4 = "${colors.base0D}"; # blue
          regular5 = "${colors.base0E}"; # magenta
          regular6 = "${colors.base0C}"; # cyan
          regular7 = "${colors.base05}"; # white
          bright0 = "${colors.base03}"; # bright black
          bright1 = "${colors.base08}"; # bright red
          bright2 = "${colors.base0B}"; # bright green
          bright3 = "${colors.base0A}"; # bright yellow
          bright4 = "${colors.base0D}"; # bright blue
          bright5 = "${colors.base0E}"; # bright magenta
          bright6 = "${colors.base0C}"; # bright cyan
          bright7 = "${colors.base07}"; # bright white
          "16" = "${colors.base09}";
          "17" = "${colors.base0F}";
          "18" = "${colors.base01}";
          "19" = "${colors.base02}";
          "20" = "${colors.base04}";
          "21" = "${colors.base06}";
        };
      };
    };
  };
}
