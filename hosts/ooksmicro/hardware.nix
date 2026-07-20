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
        name = "DSI-1";
        width = 720;
        height = 1280;
        transform = 3;
      }
    ];
  };
}
