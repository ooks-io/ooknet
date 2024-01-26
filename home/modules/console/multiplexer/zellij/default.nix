{ lib, config, ... }:
let
  inherit (config) colorscheme;
  inherit (colorscheme) colors;
  cfg = config.homeModules.console.multiplexer.zellij;
in

{
  config = lib.mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        theme = "${colorscheme.slug}";
        default_layout = "compact";
        pane_frames = false;
        themes = {
          "${colorscheme.slug}" = {
            fg = "#${colors.base05}";
            bg = "#${colors.base00}";
            black = "#${colors.base00}";
            red = "#${colors.base08}";
            green = "#${colors.base0B}";
            yellow = "#${colors.base0A}";
            blue = "#${colors.base0D}";
            magenta = "#${colors.base0E}";
            cyan = "#${colors.base0C}";
            white = "#${colors.base05}";
            orange = "#${colors.base09}";
          };
        };
      };
    };
  };
}

