{ lib, config, ... }: 

let
  inherit (lib) mkIf;
  wayland = config.ooknet.wayland;
  binds = config.ooknet.binds;
in

{
  config = mkIf (wayland.compositor == "hyprland") {
    wayland.windowManager.hyprland.settings = {
      bind = [
        # Program Launch
        "SUPER,          b,             exec,     ${binds.browser}"
        "SUPER,          return,        exec,     ${binds.terminal}"
        "SUPER,          e,             exec,     ${binds.terminalLaunch} $EDITOR"
        "SUPERSHIFT,     P,             exec,     ${binds.password}"
        "SUPER,          d,             exec,     ${binds.discord}"
        "SUPERSHIFT,     e,             exec,     ${binds.fileManager}"
        "SUPERSHIFT,     S,             exec,     ${binds.steam}"
        "SUPER,          escape,        exec,     ${binds.terminalLaunch} --title=BTOP btop"
        "SUPER CTRL,     return,        exec,     ${binds.zellijMenu}"
        "SUPER,          delete,        exec,     ${binds.powerMenu}"

        # Spotify PLayer Controls
        "SUPER,          M,             exec,     ${binds.spotify.launch}"
        "SUPER,          bracketright,  exec,     ${binds.spotify.next}"
        "SUPER,          bracketleft,   exec,     ${binds.spotify.previous}"
        "SUPER,          backslash,     exec,     ${binds.spotify.play}"

        # Brightness
        ",XF86MonBrightnessUp,          exec,     ${binds.brightness.up}"
        ",XF86MonBrightnessDown,        exec,     ${binds.brightness.down}"

        # Volume
        ",XF86AudioRaiseVolume,         exec,     ${binds.volume.up}"
        ",XF86AudioLowerVolume,         exec,     ${binds.volume.down}"
        ",XF86AudioMute,                exec,     ${binds.volume.mute}"
      
        # Window Management
        "SUPER,          Q,             killactive"
        "SUPER CTRL,     backspace,     killactive"
        "SUPERSHIFT ALT, delete,        exec, hyprkillsession"
        "SUPER,          F,             fullscreen"
        "SUPER CTRL,     F,             fakefullscreen"
        "SUPER,          Space,         togglefloating"
        "SUPER,          P,             pseudo" # dwindle
        "SUPER,          S,             togglesplit" # dwindle

        # Focus
        "SUPER,          left,          movefocus,l"
        "SUPER,          right,         movefocus,r"
        "SUPER,          up,            movefocus,u"
        "SUPER,          down,          movefocus,d"

        # Move
        "SUPERSHIFT,     left,          movewindow,l"
        "SUPERSHIFT,     right,         movewindow,r"
        "SUPERSHIFT,     up,            movewindow,u"
        "SUPERSHIFT,     down,          movewindow,d"

        #Resize
        "SUPER CTRL,     left,          resizeactive,-20 0"
        "SUPERCTRL,      right,         resizeactive,20 0"
        "SUPER CTRL,     up,            resizeactive,0 -20"
        "SUPERCTRL,      down,          resizeactive,0 20"

        # Switch workspace
        "SUPER,          1,             workspace,1"
        "SUPER,          2,             workspace,2"
        "SUPER,          3,             workspace,3"
        "SUPER,          4,             workspace,4"
        "SUPER,          5,             workspace,5"
        "SUPER,          6,             workspace,6"
        "SUPER,          7,             workspace,7"
        "SUPER,          8,             workspace,8"
        "SUPER,          9,             workspace,9"
        "SUPER,          0,             workspace,10"
        "SUPER,          comma,         workspace,e+1"
        "SUPER,          period,        workspace,e-1"
        "SUPER,          tab,           focusCurrentOrLast"

        # Move workspace
        "SUPERSHIFT,     1,             movetoworkspace,1"
        "SUPERSHIFT,     2,             movetoworkspace,2"
        "SUPERSHIFT,     3,             movetoworkspace,3"
        "SUPERSHIFT,     4,             movetoworkspace,4"
        "SUPERSHIFT,     5,             movetoworkspace,5"
        "SUPERSHIFT,     6,             movetoworkspace,6"
        "SUPERSHIFT,     7,             movetoworkspace,7"
        "SUPERSHIFT,     8,             movetoworkspace,8"
        "SUPERSHIFT,     9,             movetoworkspace,9"
        "SUPERSHIFT,     0,             movetoworkspace,10"

        # Lock Screen
        "SUPER,          Backspace,     exec,     ${binds.lock}"
      ];
        # Mouse
      bindm = [
        "SUPER,          mouse:272,     movewindow"
        "SUPER,          mouse:273,     resizewindow"
      ];
      # bindr = [
      #   "SUPER, SUPER_L, exec, killall rofi || rofi -show drun"
      # ];
    };
  };
}
