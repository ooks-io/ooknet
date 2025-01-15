{
  wayland.windowManager.hyprland.windowRules = [
    # TODO tag games for immediate
    {
      matches = {title = "TEKKEN™8";};
      rules = ["immediate"];
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
  ];
}
