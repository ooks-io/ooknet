{
  lib,
  config,
  osConfig,
  ook,
  ...
}: let
  inherit (lib) mkOption;
  inherit (lib.types) enum attrs;
in {
  options.ooknet.appearance = {
    # follows the host
    scheme = mkOption {
      type = enum ["dark" "light"];
      default = osConfig.ooknet.appearance.scheme or "dark";
    };
    colors = mkOption {
      type = attrs;
      readOnly = true;
      default = ook.themes.${config.ooknet.appearance.scheme};
    };
  };
}
