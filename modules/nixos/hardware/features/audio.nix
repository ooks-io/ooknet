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
      pulseaudio.enable = false;
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
