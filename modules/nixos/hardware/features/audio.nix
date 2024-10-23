{
  lib,
  config,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib) mkIf;
  inherit (config.ooknet.hardware) features;
in {
  # generic audio configuration
  config = mkIf (elem "audio" features) {
    hardware.pulseaudio.enable = false;
    services = {
      pipewire = {
        enable = true;
        audio.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
      };

      # realtime audio
      udev.extraRules = ''
        KERNEL=="cpu_dma_latency", GROUP="audio"
        KERNEL=="rtc0", GROUP="audio"
        KERNEL=="hpet", GROUP="audio"
      '';
    };

    security = {
      rtkit.enable = true;
      pam.loginLimits = [
        {
          domain = "@audio";
          item = "nofile";
          type = "soft";
          value = "99999";
        }
        {
          domain = "@audio";
          item = "nofile";
          type = "hard";
          value = "99999";
        }
        {
          domain = "@audio";
          item = "rtprio";
          type = "-";
          value = "99";
        }
        {
          domain = "@audio";
          item = "memlock";
          type = "-";
          value = "unlimited";
        }
        {
          domain = "@audio";
          type = "-";
          item = "nice";
          value = -11;
        }
      ];
    };
  };
}
