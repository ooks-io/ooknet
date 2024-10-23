{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.workstation) environment;
in {
  config = mkIf (environment == "hyprland") {
    services.gammastep = {
      enable = true;
      enableVerboseLogging = true;

      provider = "manual";
      latitude = -30.0;
      longitude = 150.0;

      temperature = {
        day = 6000;
        night = 4000;
      };
      settings.general.adjustment-method = "wayland";
    };
  };
}
