{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.workstation) profiles;
in {
  config = mkIf (elem "gaming" profiles) {
    programs.ns-usbloader = {
      enable = true;
    };
  };
}
