{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.ooknet.console.tools.btop;
in {
  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
    };
  };
}
