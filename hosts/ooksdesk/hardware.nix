{
  ooknet.hardware = {
    cpu = {
      type = "amd";
      amd.pstate.enable = true;
    };
    gpu = {
      type = "amd";
      lact.enable = true;
    };
    features = ["printing" "ssd" "audio" "video" "bluetooth" "peripherals"];
    monitors = [
      {
        name = "DP-1";
        primary = true;
        width = 1920;
        height = 1080;
        refreshRate = 180;
        bitDepth = 10;
      }
    ];
  };
}
