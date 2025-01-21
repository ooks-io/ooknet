{
  pkgs,
  hozen,
  osConfig,
  ook,
  ...
}: let
  inherit (hozen) color;
  inherit (ook.lib.generators) mkZellijLayout;
in {
  text = mkZellijLayout {
    zjstatusFile = "${inputs'.zjstatus.packages.default}/bin/zjstatus.wasm";
    icon = "";
    timeZone = "${osConfig.time.timeZone}";
    tabs = ''
      tab name="terminal" focus=true {
        pane name="term" cwd="$FLAKE" focus=true
      }
      tab name="editor" {
        pane name="edit" edit="$FLAKE"
      }
      tab name="git" {
        pane name="git" cwd="$FLAKE" command="lazygit"
      }
    '';
  };
    /*
    kdl
    */
    ''
      layout {
        default_tab_template {
          pane size=2 borderless=true {
            plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
              format_left  "{mode}"
              format_right "{session} {command_git_branch} {datetime}"
              format_center "#[fg=#${color.base0D},bold] {tabs}"
              format_space ""

              border_enabled  "true"
              border_char     "─"
              border_format   "#[fg=#${color.base05}]{char}"
              border_position "bottom"

              hide_frame_for_single_pane "true"

              mode_normal       "#[fg=#${color.base0D}] "
              mode_tmux         "#[fg=#${color.base0E}] "
              mode_pane         "#[fg=#${color.base08}] "
              mode_tab          "#[fg=#${color.base08}] "
              mode_rename_tab   "#[fg=#${color.base08}] "
              mode_rename_pane  "#[fg=#${color.base08}] "
              mode_session      "#[fg=#${color.base08}] "
              mode_locked       "#[fg=#${color.base05}] "
              mode_move         "#[fg=#${color.base0B}] "
              mode_resize       "#[fg=#${color.base0B}] "
              mode_prompt       "#[fg=#${color.base0A}] "
              mode_search       "#[fg=#${color.base0A}] "
              mode_enter_search "#[fg=#${color.base0A}] "

              tab_normal   "#[bg=#${color.base01}] {name} "
              tab_active   "#[bg=#${color.base02}] {name} "
              tab_separator "  "

              command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
              command_git_branch_format      "#[fg=#${color.base0C}] {stdout} "
              command_git_branch_interval    "10"
              command_git_branch_rendermode  "static"

              datetime        "#[fg=#${color.base05},bold] {format} "
              datetime_format "%I:%M %p"
              datetime_timezone "${osConfig.time.timeZone}"
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
}
