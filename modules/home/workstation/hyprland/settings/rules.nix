{osConfig, ...}: let
  monitor = builtins.elemAt osConfig.ooknet.hardware.monitors 0;

  widthMinusGaps = toString (monitor.width - 23);
in {
  wayland.windowManager.hyprland.windowRules = [
    # TODO tag games for immediate
    {
      matches = {class = "factorio";};
      rules = ["tag +games"];
    }
    {
      matches = {initialTitle = "World of Warcraft";};
      rules = ["tag +games"];
    }
    {
      matches = {title = "TEKKEN™8";};
      rules = ["tag +games"];
    }
    {
      matches = {initialTitle = "Dolphin";};
      rules = ["tag +games" "idleinhibit focus"];
    }
    {
      matches = {tag = "games";};
      rules = ["workspace 6" "immediate"];
    }
    {
      matches = {title = "Steam";};
      rules = ["workspace 5"];
    }
    {
      matches = {title = "Steam Settings";};
      rules = ["float" "size 50%" "center 1"];
    }
    {
      matches = {class = "firefox";};
      rules = ["idleinhibit fullscreen"];
    }
    {
      matches = {class = "1Password";};
      rules = ["center 1" "float" "size 50%"];
    }
    {
      matches = {title = "BTOP";};
      rules = ["float" "size 85%" "pin" "center 1" "stayfocused" "dimaround"];
    }
    {
      matches = {class = "vesktop";};
      rules = ["workspace 4 silent"];
    }
    {
      matches = {title = "^(Picture-in-Picture)$";};
      rules = ["float" "pin"];
    }
    {
      matches = {title = "^(Open Files)$";};
      rules = ["center 1" "float" "size 50%"];
    }
    {
      matches = {initialTitle = "dropdown";};
      rules = [
        "monitor 0"
        "animation slide down"
        "float"
        "move 12 46"
        "size ${widthMinusGaps} 30%"
      ];
    }
  ];
}
