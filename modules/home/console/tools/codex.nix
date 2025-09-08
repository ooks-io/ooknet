{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.ooknet.console.tools.codex;
in {
  config = mkIf cfg.enable {
    programs.codex = {
      enable = true;
    };
  };
}
