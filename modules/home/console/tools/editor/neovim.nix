{
  osConfig,
  lib,
  self',
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet) console;

  cfg = osConfig.ooknet.console.tools.nvim;
in {
  config = mkIf (cfg.enable || console.editor == "nvim") {
    home.packages = [self'.packages.ook-vim];
    home.sessionVariables.EDITOR = mkIf (console.editor == "nvim") "nvim";
  };
}

