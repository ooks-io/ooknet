{ pkgs, config, ... }:

let
  inherit (config.colorscheme) colors;
in

{
text = /* kdl */ ''
  layout {
    default_tab_template {
      pane size=2 borderless=true {
        plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
          format_left  "{mode}"
            format_right "{session} {command_git_branch} {datetime}"
            format_center "#[fg=#${colors.base0D},bold] {tabs}"
            format_space ""

            border_enabled  "true"
            border_char     "─"
            border_format   "#[fg=#${colors.base05}]{char}"
            border_position "bottom"

            hide_frame_for_single_pane "true"

            mode_normal       "#[fg=#${colors.base0D}] "
            mode_tmux         "#[fg=#${colors.base0E}] "
            mode_pane         "#[fg=#${colors.base08}] "
            mode_tab          "#[fg=#${colors.base08}] "
            mode_rename_tab   "#[fg=#${colors.base08}] "
            mode_rename_pane  "#[fg=#${colors.base08}] "
            mode_session      "#[fg=#${colors.base08}] "
            mode_locked       "#[fg=#${colors.base05}] "
            mode_move         "#[fg=#${colors.base0B}] "
            mode_resize       "#[fg=#${colors.base0B}] "
            mode_prompt       "#[fg=#${colors.base0A}] "
            mode_search       "#[fg=#${colors.base0A}] "
            mode_enter_search "#[fg=#${colors.base0A}] "

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
      tab name="edit" focus=true {
          pane edit="./" name="edit" focus=true size="85%" borderless=true
          pane name="term" focus=false size="15%" borderless=false
      }
      tab name="git" focus=false {
          pane name="git" focus=false command="lazygit"
      }
  }
'';
}
