{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (osConfig.ooknet.workstation) default;
  cfg = osConfig.ooknet.workstation.programs.chromium;
in {
  config = mkMerge [
    (mkIf (cfg.enable || default.browser == "chromium") {
      programs.chromium = {
        enable = true;
      };
    })
    (mkIf default.browser
      == "chromium" {
        home.sessionVariables.BROWSER = "chromium";
      })
  ];
}
