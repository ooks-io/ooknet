{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.ooknet.console.tools.ffmpeg;
in {
  config = mkIf cfg.enable {
    # TODO: configure scripts
    home.packages = [pkgs.ffmpeg];
  };
}
