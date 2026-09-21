{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) optionalAttrs mapAttrs' nameValuePair mkIf mkOption;
  inherit (lib.types) nullOr lines submodule str attrsOf;

  cfg = config.programs.zellij;

  mkZellijLayout = {
    zjstatus,
    icon ? "",
    timeZone,
    tabs ? '''',
  }:
  # kdl
  ''
    layout {
      default_tab_template {
        pane size=2 borderless=true {
          plugin location="file:${zjstatus}" {
            format_left  "{mode}"
            format_right "{session} {datetime}"
            format_center "#[fg=blue,bold] {tabs}"
            format_space ""

            border_enabled  "true"
            border_char     "─"
            border_format   "#[fg=white]{char}"
            border_position "bottom"

            hide_frame_for_single_pane "true"

            mode_normal       "#[fg=blue]${icon} "
            mode_tmux         "#[fg=magenta]${icon} "
            mode_pane         "#[fg=red]${icon} "
            mode_tab          "#[fg=red]${icon} "
            mode_rename_tab   "#[fg=red]${icon} "
            mode_rename_pane  "#[fg=red]${icon} "
            mode_session      "#[fg=red]${icon} "
            mode_locked       "#[fg=white]${icon} "
            mode_move         "#[fg=green]${icon} "
            mode_resize       "#[fg=green]${icon} "
            mode_prompt       "#[fg=yellow]${icon} "
            mode_search       "#[fg=yellow]${icon} "
            mode_enter_search "#[fg=yellow]${icon} "

            tab_normal   "#[bg=black] {name} "
            tab_active   "#[bg=bright_black] {name} "
            tab_separator "  "

            datetime        "#[fg=white,bold] {format} "
            datetime_format "%I:%M %p"
            datetime_timezone "${timeZone}"
          }
        }
      children
      }
      ${tabs}
    }
  '';

  layoutModule = submodule {
    options = {
      icon = mkOption {
        type = str;
        description = "Icon to display on the status bar";
        default = "";
      };
      timeZone = mkOption {
        type = str;
        description = "Timezone for the datetime display";
        default = osConfig.time.timeZone;
      };
      zjstatus = mkOption {
        type = str;
        # 0.21.0 matches the pinned zellij 0.42.2, 0.23+ targets zellij-tile 0.44
        default = "${pkgs.fetchurl {
          url = "https://github.com/dj95/zjstatus/releases/download/v0.21.0/zjstatus.wasm";
          hash = "sha256-p6JTnAyim0T3TkJzGhEitzc3JpPovL5k7jb8gv+oLD4=";
        }}";
      };
      tabs = mkOption {
        type = lines;
        default = '''';
        description = "KDL configuration for layouts tabs";
      };
    };
  };
in {
  options.programs.zellij = {
    # TODO: turn this into a binds options
    extraSettings = mkOption {
      type = nullOr lines;
      default = null;
      description = "Additional settings in KDL format";
    };
    _layouts = mkOption {
      type = attrsOf layoutModule;
      description = "Zellij layouts with zjstatus";
    };
  };
  config = mkIf cfg.enable {
    xdg.configFile =
      mapAttrs' (name: layout:
        nameValuePair "zellij/layouts/${name}.kdl" {
          text = mkZellijLayout layout;
        })
      cfg._layouts
      // optionalAttrs (cfg.extraSettings != null) {
        "zellij/config.kdl".text = cfg.extraSettings;
      };
  };
}
