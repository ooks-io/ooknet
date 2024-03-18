{ lib, config, pkgs, ... }: 

let
    cfg = config.homeModules.desktop.wayland.windowManager.hyprland;
in

{
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    bind = let
      terminal = config.home.sessionVariables.TERMINAL;
      browser = config.home.sessionVariables.BROWSER;
      editor = config.home.sessionVariables.EDITOR;
      locker = config.home.sessionVariables.LOCKER;

      spotifyctl = "${pkgs.spotify-player}/bin/spotify_player";
      discord = "${pkgs.vesktop}/bin/vesktop";
      
      explorer = "${pkgs.cinnamon.nemo-with-extensions}/bin/nemo";

      password = "${pkgs._1password-gui}/bin/1password";
    in [

      # Program Launch
      "SUPER,          b,             exec,     ${browser}"
      "SUPER,          return,        exec,     ${terminal}"
      "SUPER,          e,             exec,     ${terminal} ${editor}"
      "SUPERSHIFT,     P,             exec,     ${password}"
      "SUPER,          d,             exec,     ${discord}"
      "SUPERSHIFT,     e,             exec,     ${explorer}"
      "SUPERSHIFT,     S,             exec,     steam"
      "SUPER,          escape,        exec,     ${terminal} --title=BTOP btop"
      
      

      # Spotify PLayer Controls

      "SUPER,          bracketright,  exec,     ${spotifyctl} playback next"
      "SUPER,          bracketleft,   exec,     ${spotifyctl} playback previous"
      "SUPER,          backslash,     exec,     ${spotifyctl} playback play-pause"

      # Screenshot

      ",               Print,         exec,     grimblast --notify --cursor copysave area"
      "SUPER,          Print,         exec,     grimblast --notify --cursor copysave screen"
      "SUPER,          r,             exec,     hyprrecord -a -w copysave screen video"
      "SUPER CTRL,     r,             exec,     hyprrecord -a -w copysave area video"
      "SUPER ALT,      r,             exec,     hyprrecord -w copysave area gif"
      

      # Brightness

      ",XF86MonBrightnessUp,          exec,     hyprbrightness up"
      ",XF86MonBrightnessDown,        exec,     hyprbrightness down"

      # Volume

      ",XF86AudioRaiseVolume,         exec,     hyprvolume up"
      ",XF86AudioLowerVolume,         exec,     hyprvolume down"
      ",XF86AudioMute,                exec,     hyprvolume mute"
      
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
      "SUPER,          Backspace,     exec,     ${locker}"
    ];
      # Mouse
    bindm = [
      "SUPER,          mouse:272,     movewindow"
      "SUPER,          mouse:273,     resizewindow"
    ];
    bindr = [
      "SUPER, SUPER_L, exec, killall anyrun | anyrun"
    ];
  };
}
