{
  ooknet.hardware = {
    cpu.type = "intel";
    gpu.type = "nvidia";
    features = ["ssd" "audio" "video" "bluetooth"];
    monitors = [
      {
        name = "DP-3";
        primary = true;
        width = 1920;
        height = 1080;
        refreshRate = 180;
      }
    ];
  };
}
