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
    features = ["printing" "ssd" "audio" "video"];
    monitors = [
      {
        name = "DP-2";
        primary = true;
        width = 1920;
        height = 1080;
        refreshRate = 180;
      }
    ];
  };
}
