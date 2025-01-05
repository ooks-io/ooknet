{
  ooknet.hardware = {
    cpu.type = "amd";
    cpu.amd.pstate.enable = true;
    gpu.type = "amd";
    features = ["printing" "ssd" "audio" "video"];
    monitors = [
      {
        name = "DP-1";
        primary = true;
        width = 2560;
        height = 1440;
        refreshRate = 144;
        workspace = "1";
        x = 1920;
        y = 100;
      }
      {
        name = "DP-2";
        width = 1920;
        height = 1080;
        refreshRate = 180;
        x = 840;
        transform = 1;
      }
    ];
  };
}
