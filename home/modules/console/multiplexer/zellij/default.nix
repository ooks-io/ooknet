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
                  format_left  "{mode} #[fg=#${colors.base0D},bold] {tabs}"
                  format_right "{session} {command_git_branch} {datetime}"
                  format_space ""

                  border_enabled  "true"
                  border_char     "─"
                  border_format   "#[fg=#${colors.base05}]{char}"
                  border_position "bottom"

                  hide_frame_for_single_pane "true"

                  mode_normal       "#[fg=#${colors.base0D}] "
                  mode_tmux         "#[fg=#${colors.base0E}] "
                  mode_pane         "#[fg=#${colors.base08}] "
                  mode_tab          "#[fg=#${colors.base08}] "
                  mode_rename_tab   "#[fg=#${colors.base08}] "
                  mode_rename_pane  "#[fg=#${colors.base08}] "
                  mode_session      "#[fg=#${colors.base08}] "
                  mode_locked       "#[fg=#${colors.base05}] "
                  mode_move         "#[fg=#${colors.base0B}] "
                  mode_resize       "#[fg=#${colors.base0B}] "
                  mode_prompt       "#[fg=#${colors.base0A}] "
                  mode_search       "#[fg=#${colors.base0A}] "
                  mode_enter_search "#[fg=#${colors.base0A}] "

                  tab_normal   "#[bg=#${colors.base01}] {name} "
                  tab_active   "#[bg=#${colors.base02}] {name} "
                  tab_separator "  "

                  command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                  command_git_branch_format      "#[fg=#${colors.base0C}] {stdout} "
                  command_git_branch_interval    "10"
                  command_git_branch_rendermode  "static"

                  datetime        "#[fg=#${colors.base05},bold] {format} "
                  datetime_format "%I:%M %p"
                  datetime_timezone "${config.home.sessionVariables.TZ}"
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
                  format_left  "{mode} #[fg=#${colors.base0D},bold] {tabs}"
                  format_right "{session} {command_git_branch} {datetime}"
                  format_space ""

                  border_enabled  "true"
                  border_char     "─"
                  border_format   "#[fg=#${colors.base05}]{char}"
                  border_position "bottom"

                  hide_frame_for_single_pane "true"

                  mode_normal       "#[fg=#${colors.base0D}] "
                  mode_tmux         "#[fg=#${colors.base0E}] "
                  mode_pane         "#[fg=#${colors.base08}] "
                  mode_tab          "#[fg=#${colors.base08}] "
                  mode_rename_tab   "#[fg=#${colors.base08}] "
                  mode_rename_pane  "#[fg=#${colors.base08}] "
                  mode_session      "#[fg=#${colors.base08}] "
                  mode_locked       "#[fg=#${colors.base05}] "
                  mode_move         "#[fg=#${colors.base0B}] "
                  mode_resize       "#[fg=#${colors.base0B}] "
                  mode_prompt       "#[fg=#${colors.base0A}] "
                  mode_search       "#[fg=#${colors.base0A}] "
                  mode_enter_search "#[fg=#${colors.base0A}] "

                  tab_normal   "#[bg=#${colors.base01}] {name} "
                  tab_active   "#[bg=#${colors.base02}] {name} "
                  tab_separator "  "

                  command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                  command_git_branch_format      "#[fg=#${colors.base0C}] {stdout} "
                  command_git_branch_interval    "10"
                  command_git_branch_rendermode  "static"

                  datetime        "#[fg=#${colors.base05},bold] {format} "
                  datetime_format "%I:%M %p"
                  datetime_timezone "${config.home.sessionVariables.TZ}"
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

