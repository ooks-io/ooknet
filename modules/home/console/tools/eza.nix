{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.ooknet.console.tools.eza;
in {
  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      git = true;
      icons = "auto";
    };
  };
}
