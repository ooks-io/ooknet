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
        default_layout = "base";
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
    xdg.configFile."zellij/layouts/base.kdl".text = /* kdl */ ''
      layout {
      default_tab_template {
          pane size=2 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                  format_left  "{mode} #[fg=#89B4FA,bold] {tabs}"
                  format_right "{session} {command_git_branch} {datetime}"
                  format_space ""

                  border_enabled  "true"
                  border_char     "─"
                  border_format   "#[fg=blue]{char}"
                  border_position "bottom"

                  hide_frame_for_single_pane "true"

                  mode_normal       "#[fg=blue] "
                  mode_tmux         "#[fg=purple] "
                  mode_pane         "#[fg=red] "
                  mode_tab          "#[fg=red] "
                  mode_rename_tab   "#[fg=red] "
                  mode_rename_pane  "#[fg=red] "
                  mode_session      "#[fg=red] "
                  mode_locked       "#[fg=white] "
                  mode_move         "#[fg=green] "
                  mode_resize       "#[fg=green] "
                  mode_prompt       "#[fg=yellow] "
                  mode_search       "#[fg=yellow] "
                  mode_enter_search "#[fg=yellow] "
            

                  tab_normal   "#[bg=#3C3836] {name} "
                  tab_active   "#[bg=#504945] {name} "
                  tab_separator "  "

                  command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                  command_git_branch_format      "#[fg=blue] {stdout} "
                  command_git_branch_interval    "10"
                  command_git_branch_rendermode  "static"

                  datetime        "#[fg=#6C7086,bold] {format} "
                  datetime_format "%I:%M %p"
                  datetime_timezone "Pacific/Auckland"
              }
          }
          children
      }

          tab name="terminal" focus=true {
              pane name="term" cwd="~" focus=true
          }
      }
    '';
    
    xdg.configFile."zellij/layouts/flake.kdl".text = /* kdl */ ''
      layout {
      default_tab_template {
          pane size=2 borderless=true {
              plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                  format_left  "{mode} #[fg=#89B4FA,bold] {tabs}"
                  format_right "{session} {command_git_branch} {datetime}"
                  format_space ""

                  border_enabled  "true"
                  border_char     "─"
                  border_format   "#[fg=blue]{char}"
                  border_position "bottom"

                  hide_frame_for_single_pane "true"

                  mode_normal       "#[fg=blue] "
                  mode_tmux         "#[fg=purple] "
                  mode_pane         "#[fg=red] "
                  mode_tab          "#[fg=red] "
                  mode_rename_tab   "#[fg=red] "
                  mode_rename_pane  "#[fg=red] "
                  mode_session      "#[fg=red] "
                  mode_locked       "#[fg=white] "
                  mode_move         "#[fg=green] "
                  mode_resize       "#[fg=green] "
                  mode_prompt       "#[fg=yellow] "
                  mode_search       "#[fg=yellow] "
                  mode_enter_search "#[fg=yellow] "
        

                  tab_normal   "#[bg=#3C3836] {name} "
                  tab_active   "#[bg=#504945] {name} "
                  tab_separator "  "

                  command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                  command_git_branch_format      "#[fg=blue] {stdout} "
                  command_git_branch_interval    "10"
                  command_git_branch_rendermode  "static"

                  datetime        "#[fg=#6C7086,bold] {format} "
                  datetime_format "%I:%M %p"
                  datetime_timezone "Pacific/Auckland"
              }
          }
          children
      }

          tab name="terminal" focus=true {
              pane name="term" cwd="$FLAKE" focus=true
          }
          tab name="editor" {
              pane name="edit" edit="$FLAKE"
          }
          tab name="git" {
              pane name="git" cwd="$FLAKE" command="lazygit"
          }
      }
    '';
    home.shellAliases = {
      zjf = "zellij --layout flake";
    };
  };
}

