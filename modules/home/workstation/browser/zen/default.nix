{
  inputs',
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.workstation) default;

  cfg = osConfig.ooknet.workstation.programs.zen;
in {
  config = mkIf (cfg.enable || default.browser == "zen") {
    home.packages = [inputs'.zen-browser.packages.default];
  };
}
