{
  ooknet.hardware = {
    cpu.type = "intel";
    gpu.type = "intel";
    features = [
      "bluetooth"
      "backlight"
      "battery"
      "ssd"
      "audio"
      "video"
    ];
    monitors = [
      {
        primary = true;
        name = "eDP-1";
        width = 1920;
        height = 1080;
      }
    ];
  };
}
