{ lib, config, pkgs, ... }:
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
    xdg.configFile."zellij/layouts/zjstatus.kld".text = /* kdl */ ''
      layout {
          pane split_direction="vertical" {
              pane
          }

          pane size=1 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                  format_left  "{mode} #[fg=#89B4FA,bold]{session} {tabs}"
                  format_right "{command_git_branch} {datetime}"
                  format_space ""

                  border_enabled  "false"
                  border_char     "─"
                  border_format   "#[fg=#6C7086]{char}"
                  border_position "top"

                  hide_frame_for_single_pane "true"

                  mode_normal  "#[bg=blue] "
                  mode_tmux    "#[bg=#ffc387] "

                  tab_normal   "#[fg=#6C7086] {name} "
                  tab_active   "#[fg=#9399B2,bold,italic] {name} "

                  command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                  command_git_branch_format      "#[fg=blue] {stdout} "
                  command_git_branch_interval    "10"
                  command_git_branch_rendermode  "static"

                  datetime        "#[fg=#6C7086,bold] {format} "
                  datetime_format "%A, %d %b %Y %H:%M"
                  datetime_timezone "Pacific/Auckland"
              }
          }
      }
    '';
  };
}

