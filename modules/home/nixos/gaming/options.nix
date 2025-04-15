{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) str;
  cfg = config.ooknet.gaming;
in {
  options.ooknet.gaming = {
    enable = mkEnableOption;

    gamesPath = mkOption {
      type = str;
      default = "${config.home.homeDirectory}/Games";
      description = "Location where games will be stored.";
    };

    prefixPath = mkOption {
      type = str;
      default = "${cfg.gamesPath}/prefixes";
    };
    compatDataPath = mkOption {
      type = str;
      default = "${cfg.prefixPath}/compatdata";
    };
  };
  config = mkIf cfg.enable {
    xdg.userDirs.XDG_GAMES_DIR = cfg.gamesPath;
  };
}
