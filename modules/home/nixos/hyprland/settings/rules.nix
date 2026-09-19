{osConfig, ...}: let
  monitor = builtins.elemAt osConfig.ooknet.hardware.monitors 0;

  widthMinusGaps = toString (monitor.width - 23);
in {
  wayland.windowManager.hyprland.windowRules = [
    # TODO tag games for immediate
    {
      matches.initial_title = "Syncthing Tray";
      rules = {
        float = true;
        center = true;
        size = "50% 50%";
      };
    }
    {
      matches.class = "factorio";
      rules.tag = "+games";
    }
    {
      matches.title = "TEKKEN™8";
      rules.tag = "+games";
    }
    {
      matches.initial_title = "Dolphin";
      rules = {
        tag = "+games";
        idle_inhibit = "focus";
      };
    }
    {
      matches.tag = "games";
      rules = {
        workspace = "6";
        immediate = true;
      };
    }
    {
      matches.title = "Steam";
      rules.workspace = "5";
    }
    {
      matches.title = "Steam Settings";
      rules = {
        float = true;
        size = "50% 50%";
        center = true;
      };
    }
    {
      matches.class = "firefox";
      rules.idle_inhibit = "fullscreen";
    }
    {
      matches.class = "1Password";
      rules = {
        center = true;
        float = true;
        size = "50% 50%";
      };
    }
    {
      matches.title = "BTOP";
      rules = {
        float = true;
        size = "85% 85%";
        pin = true;
        center = true;
        stay_focused = true;
        dim_around = true;
      };
    }
    {
      matches.class = "vesktop";
      rules.workspace = "4 silent";
    }
    {
      matches.title = "^(Picture-in-Picture)$";
      rules = {
        float = true;
        pin = true;
      };
    }
    {
      matches.title = "^(Open Files)$";
      rules = {
        center = true;
        float = true;
        size = "50% 50%";
      };
    }
    {
      matches.initial_title = "dropdown";
      rules = {
        monitor = "0";
        animation = "slide down";
        float = true;
        move = "12 46";
        size = "${widthMinusGaps} 30%";
      };
    }
  ];
}
