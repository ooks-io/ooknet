{ config, lib, ... }:

let
  cfg = config.systemModules.pipewire;
in

{
  config = lib.mkIf cfg.enable {
    hardware.pulseaudio.enable = lib.mkForce false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
}

