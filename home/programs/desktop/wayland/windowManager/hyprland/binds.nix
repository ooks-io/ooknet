{ lib, config, pkgs, ... }: 

  let
    cfg = config.programs.desktop.wayland.windowManager.hyprland;
    light = "${pkgs.light}/bin/light";
    notifysend = "${pkgs.libnotify}/bin/notify-send";
    #pamixer = "${pkgs.pamixer}/bin/pamixer";

    brightnessScript = pkgs.writeShellScriptBin "brightness" ''
      #!/bin/sh

      if [ "$1" == "up" ]; then
      ${light} -A 10
    elif [ "$1" == "down" ]; then
      ${light} -U 10
    else
      echo "Invalid argument"
      exit 1
    fi

    BRIGHTNESS=$(${light} -G | awk -F'.' '{print$1}')

    ${notifysend} --app-name="system-notify" -h string:x-canonical-private-synchronous:sys-notify "󰃠  $BRIGHTNESS%"
    '';

    volumeScript = pkgs.writeShellScriptBin "volume" ''
    #!/bin/sh

    if [ "$1" == "up" ]; then
      pamixer --increase 5
    elif [ "$1" == "down" ]; then
      pamixer --decrease 5
    elif [ "$1" == "mute" ]; then
      pamixer --toggle-mute
    fi

    VOLUME=$(pamixer --get-volume-human)

    ${notifysend} --app-name="system-notify" -h string:x-canonical-private-synchronous:sys-notify "  $VOLUME"
  '';
in

  {
  wayland.windowManager.hyprland.settings = lib.mkIf cfg.enable {
    bind = let
      terminal = config.home.sessionVariables.TERMINAL;
      browser = config.home.sessionVariables.BROWSER;
      editor = config.home.sessionVariables.EDITOR;

      bright = "${brightnessScript}/bin/brightness";
      volume = "${volumeScript}/bin/volume";

      swaylock = "${config.programs.swaylock.package}/bin/swaylock";
      spotify = "${terminal} -e spotify_player";
      spotifyctl = "${pkgs.spotify-player}/bin/spotify_player";
      discord = "${pkgs.vesktop}/bin/vesktop";
    
      #makoctl = "${config.services.mako.package}/bin/makoctl";

      password = "${pkgs._1password-gui}/bin/1password --enable-features=UseOzonePlatform --ozone-platform=wayland";
      
      #playerctl = "${config.services.playerctld.package}/bin/playerctl";
      #playerctld = "${config.services.playerctld.package}/bin/playerctld";
      #pactl = "${pkgs.pulseaudio}/bin/pactl";
    in [

      # Program Launch
      "SUPER,          b,             exec,     ${browser}"
      "SUPER,          return,        exec,     ${terminal}"
      "SUPER,          e,             exec,     ${editor}"
      "SUPER,          m,             exec,     ${spotify}"
      "SUPERSHIFT,     P,             exec,     ${password}"
      "SUPER,          d,             exex,     ${discord}"

      # Spotify PLayer Controls

      "SUPER,          bracketright,  exec,     ${spotifyctl} playback next"
      "SUPER,          bracketleft,   exec,     ${spotifyctl} playback previous"
      "SUPER,          backslash,     exec,     ${spotifyctl} playback play-pause"

      # Brightness

      ",XF86MonBrightnessUp,          exec,     ${bright} up"
      ",XF86MonBrightnessDown,        exec,     ${bright} down"

      # Volume

      ",XF86AudioRaiseVolume,         exec,     ${volume} up"
      ",XF86AudioLowerVolume,         exec,     ${volume} down"
      ",XF86AudioMute,                exec,     ${volume} mute"
      
      # Window Management
      
      "SUPER,          Q,             killactive"
      "SUPER CTRL,     backspace,     killactive"
      "SUPERSHIFT ALT, delete,        exit"
      "SUPER,          F,             fullscreen"
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
      "SUPER,          Backspace,     exec,     ${swaylock}"
    ];
      # Mouse
    bindm = [
      "SUPER,          mouse:272,     movewindow"
      "SUPER,          mouse:273,     resizewindow"
    ];
  };
}
