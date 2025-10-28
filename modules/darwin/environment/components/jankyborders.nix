{
  lib,
  ook,
  config,
  ...
}: let
  inherit (ook) color;
  inherit (lib) mkIf;
  inherit (config.ooknet.workstation) environment;
in {
  config = mkIf (environment == "aerospace") {
    # jankyborders is a service that adds borders to frames on macos
    services.jankyborders = {
      enable = true;
      active_color = "0xff${color.border.active}";
      inactive_color = "0xff${color.border.inactive}";
      width = 5.0;
      # what layer the border will sit on, available options:
      # above, below
      # warning, this will break things.
      order = "above";
      # we whitelist applications as certain apps do not play well with borders, namely AppStore
      whitelist = [
        "ghostty"
        "zen"
      ];
    };
  };
}
