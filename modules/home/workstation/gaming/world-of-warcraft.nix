{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption;
  inherit (lib.types) str package;
  inherit (config.ooknet) gaming;
  gamesDir = config.xdg.userDirs.extraConfig.XDG_GAMES_DIR;
  cfg = config.ooknet.gaming.world-of-warcraft;
in {
  options.ooknet.gaming.world-of-warcraft = {
    enable = mkEnableOption "Enable the World of Warcraft module";

    proton = {
      package = mkOption {
        type = package;
        default = pkgs.proton-ge-custom;
      };
      prefix = {
        path = mkOption {
          type = str;
          default = "${gaming.prefixPath}/WoW";
        };
      };
      compatDataPath = mkOption {
        type = str;
        default = "${gaming.compatDataPath}/";
      };
    };

    gamePrefixPath = mkOption {
      type = str;
      default = "${cfg.winePrefixesPath}/WoW";
      description = "Location where the World of Warcraft prefix will be stored.";
    };

    gamePath = mkOption {
      type = str;
      default = "${cfg.world-of-warcraft.gamePrefixPath}/drive_c/Program Files (x86)/World of Warcraft";
      description = "Location where the World of Warcraft installation will be symlinked.";
    };

    gameSharedPath = mkOption {
      type = str;
      default = "${cfg.wineProgramsPath}/World Of Warcraft";
      description = "Location where World of Warcraft game files are stored.";
    };
  };
  config =
    mkIf cfg.enable {
    };
}

