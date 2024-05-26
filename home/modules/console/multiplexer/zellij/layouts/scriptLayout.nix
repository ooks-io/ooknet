{ pkgs, config, ... }:

let
  inherit (config.colorscheme) palette;
in

{
text = /* kdl */ ''
  layout {
    default_tab_template {
      pane size=2 borderless=true {
        plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
          format_left  "{mode}"
            format_right "{session} {command_git_branch} {datetime}"
            format_center "#[fg=#${palette.base0D},bold] {tabs}"
            format_space ""

            border_enabled  "true"
            border_char     "─"
            border_format   "#[fg=#${palette.base05}]{char}"
            border_position "bottom"

            hide_frame_for_single_pane "true"

            mode_normal       "#[fg=#${palette.base0D}] "
            mode_tmux         "#[fg=#${palette.base0E}] "
            mode_pane         "#[fg=#${palette.base08}] "
            mode_tab          "#[fg=#${palette.base08}] "
            mode_rename_tab   "#[fg=#${palette.base08}] "
            mode_rename_pane  "#[fg=#${palette.base08}] "
            mode_session      "#[fg=#${palette.base08}] "
            mode_locked       "#[fg=#${palette.base05}] "
            mode_move         "#[fg=#${palette.base0B}] "
            mode_resize       "#[fg=#${palette.base0B}] "
            mode_prompt       "#[fg=#${palette.base0A}] "
            mode_search       "#[fg=#${palette.base0A}] "
            mode_enter_search "#[fg=#${palette.base0A}] "

            tab_normal   "#[bg=#${palette.base01}] {name} "
            tab_active   "#[bg=#${palette.base02}] {name} "
            tab_separator "  "

            command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
            command_git_branch_format      "#[fg=#${palette.base0C}] {stdout} "
            command_git_branch_interval    "10"
            command_git_branch_rendermode  "static"

            datetime        "#[fg=#${palette.base05},bold] {format} "
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
