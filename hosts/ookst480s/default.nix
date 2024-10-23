{
  pkgs,
  lib,
  ...
}: {
  imports = [./file-system.nix];
  ooknet = {
    host = {
      admin = {
        name = "ooks";
        shell = "fish";
        homeManager = true;
      };
    };
    workstation = {
      profiles = ["media" "gaming" "communication"];
      environment = "hyprland";
      theme = "minimal";
    };
    console = {
      profile = "standard";
    };
    hardware = {
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
          workspace = "1";
        }
      ];
    };
  };
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  system.stateVersion = lib.mkDefault "23.11";
}
