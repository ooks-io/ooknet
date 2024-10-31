{
  ooknet.hardware = {
    cpu.type = "amd";
    cpu.amd.pstate.enable = true;
    gpu.type = "amd";
    features = ["printing" "ssd" "audio" "video"];
    monitors = [
      {
        name = "DP-3";
        primary = true;
        width = 1920;
        height = 1080;
        refreshRate = 180;
        workspace = "1";
      }
    ];
  };
}
