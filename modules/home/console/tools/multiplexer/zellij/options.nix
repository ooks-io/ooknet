{
  lib,
  config,
  pkgs,
  osConfig,
  ook,
  ...
}: let
  inherit (ook) color;
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
            format_center "#[fg=#${color.base0D},bold] {tabs}"
            format_space ""

            border_enabled  "true"
            border_char     "─"
            border_format   "#[fg=#${color.base05}]{char}"
            border_position "bottom"

            hide_frame_for_single_pane "true"

            mode_normal       "#[fg=#${color.base0D}]${icon} "
            mode_tmux         "#[fg=#${color.base0E}]${icon} "
            mode_pane         "#[fg=#${color.base08}]${icon} "
            mode_tab          "#[fg=#${color.base08}]${icon} "
            mode_rename_tab   "#[fg=#${color.base08}]${icon} "
            mode_rename_pane  "#[fg=#${color.base08}]${icon} "
            mode_session      "#[fg=#${color.base08}]${icon} "
            mode_locked       "#[fg=#${color.base05}]${icon} "
            mode_move         "#[fg=#${color.base0B}]${icon} "
            mode_resize       "#[fg=#${color.base0B}]${icon} "
            mode_prompt       "#[fg=#${color.base0A}]${icon} "
            mode_search       "#[fg=#${color.base0A}]${icon} "
            mode_enter_search "#[fg=#${color.base0A}]${icon} "

            tab_normal   "#[bg=#${color.base01}] {name} "
            tab_active   "#[bg=#${color.base02}] {name} "
            tab_separator "  "

            datetime        "#[fg=#${color.base05},bold] {format} "
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
