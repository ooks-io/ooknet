{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.ooknet.console.tools.direnv;
in {
  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
