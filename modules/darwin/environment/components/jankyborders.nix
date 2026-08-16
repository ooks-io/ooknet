{
  lib,
  ook,
  config,
  pkgs,
  ...
}: let
  inherit (ook) color;
  inherit (lib) mkIf;
  inherit (config.ooknet.workstation) environment;

  jankyborders-thin = pkgs.jankyborders.overrideAttrs (old: {
    postPatch =
      (old.postPatch or "")
      + ''
        substituteInPlace src/border.h \
          --replace-fail "#define BORDER_TSMW 8.f" "#define BORDER_TSMW 2.f" \
          --replace-fail "#define BORDER_TSMN 3.27f" "#define BORDER_TSMN 1.0f"
      '';
  });
in {
  config = mkIf (environment == "aerospace") {
    # jankyborders is a service that adds borders to frames on macos
    services.jankyborders = {
      enable = true;
      package = jankyborders-thin;
      active_color = "0xff${color.border.active}";
      inactive_color = "0xff${color.border.inactive}";
      width = 2.0;
      hidpi = true;
      style = "square";
      order = "above";
      # we whitelist applications as certain apps do not play well with borders, namely AppStore
      whitelist = [
        "ghostty"
        "zen"
      ];
    };
  };
}
