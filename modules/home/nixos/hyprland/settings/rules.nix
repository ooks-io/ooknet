{osConfig, ...}: let
  monitor = builtins.elemAt osConfig.ooknet.hardware.monitors 0;

  widthMinusGaps = toString (monitor.width - 23);
in {
  wayland.windowManager.hyprland.windowRules = [
    # TODO tag games for immediate
    {
      matches = {initial_title = "Syncthing Tray";};
      rules = ["float 1" "center 1" "size 50%"];
    }
    {
      matches = {class = "factorio";};
      rules = ["tag +games"];
    }
    {
      matches = {title = "TEKKEN™8";};
      rules = ["tag +games"];
    }
    {
      matches = {initial_title = "Dolphin";};
      rules = ["tag +games" "idle_inhibit focus"];
    }
    {
      matches = {tag = "games";};
      rules = ["workspace 6" "immediate 1"];
    }
    {
      matches = {title = "Steam";};
      rules = ["workspace 5"];
    }
    {
      matches = {title = "Steam Settings";};
      rules = ["float 1" "size 50%" "center 1"];
    }
    {
      matches = {class = "firefox";};
      rules = ["idle_inhibit fullscreen"];
    }
    {
      matches = {class = "1Password";};
      rules = ["center 1" "float 1" "size 50%"];
    }
    {
      matches = {title = "BTOP";};
      rules = ["float 1" "size 85%" "pin 1" "center 1" "stay_focused 1" "dim_around 1"];
    }
    {
      matches = {class = "vesktop";};
      rules = ["workspace 4 silent"];
    }
    {
      matches = {title = "^(Picture-in-Picture)$";};
      rules = ["float 1" "pin 1"];
    }
    {
      matches = {title = "^(Open Files)$";};
      rules = ["center 1" "float 1" "size 50%"];
    }
    {
      matches = {initial_title = "dropdown";};
      rules = [
        "monitor 0"
        "animation slide down"
        "float 1"
        "move 12 46"
        "size ${widthMinusGaps} 30%"
      ];
    }
  ];
}
