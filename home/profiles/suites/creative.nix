{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (osConfig.ooknet.host) profiles;
in {
  config = mkIf (elem "creative" profiles) {
    ooknet.creative = {
      audacity.enable = true;
      inkscape.enable = true;
    };
  };
}
