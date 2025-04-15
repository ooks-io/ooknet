{
  lib,
  self',
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) package str path attrsOf anything bool int;
  cfg = config.ooknet.gaming.project-plus;
in {
  options.ooknet.gaming.project-plus = {
    enable = mkEnableOption "Enable Project Plus";
    package = mkOption {
      type = package;
      default = self'.packages.project-plus.override {
        inherit (cfg) userDir;
      };
    };
    userDir = mkOption {
      type = str;
      default = "${config.xdg.configHome}/project-plus";
      description = ''
        Location of the Dolphin User directory, this is the path that the wrapped package
        will use for User configuration. defaults to "\$\{config.xdg.configHome}/project-plus"
      '';
    };

    launcherSource = mkOption {
      type = path;
      default = "${self'.packages.fpp-launcher}/Launcher";
      description = ''
        Location of the faster-project-plus launcher files.
      '';
    };
    sdCardSource = mkOption {
      type = path;
      default = "${self'.packages.fpp-sd}/sd.raw";
      description = ''
        Location of the faster-project-plus sd card
      '';
    };
    userSource = mkOption {
      type = path;
      default = "${self'.packages.fpp-config}/Binaries/User";
    };

    netplay = {
      nickname = mkOption {
        type = str;
        default = "Player";
        description = "Netplay nickname displayed to other players";
      };
      disableMusic = mkOption {
        type = bool;
        default = true;
        description = "Whether to disable music during netplay";
      };
      buffer = mkOption {
        type = int;
        default = 4;
        description = "Default netplay buffer";
      };
    };

    analytics = {
      enable = mkEnableOption "Enable anaylytics";
    };

    startFullscreen = mkEnableOption "Start emulated game fullscreen";

    gamesDir = mkOption {
      type = str;
      default = "./Games";
      description = ''
        Location of the directory that stores all game isos, this is where you should store
        your brawl iso. Defaults to "./Brawl" (The . is relative to the User dolphin directory)
      '';
    };

    extraSettings = mkOption {
      type = attrsOf anything;
      default = {};
      description = ''
        Additional settings for Dolphin.ini
      '';
    };
  };
  config = mkIf cfg.enable {
    home.packages = [cfg.package];
    xdg.configFile = {
      "project-plus/Config/Dolphin.ini" = {
        text = lib.generators.toINI {} {
          # default settings to ensure project-plus works OOTB.
          General = {
            IsoPaths = 2;
            IsoPath0 = "${cfg.userDir}/Games";
            IsoPath1 = "${cfg.userDir}/Launcher";
            WiiSDCardPath = "${cfg.userDir}/Wii/sd.raw";
          };
          Core = {
            DefaultISO = "${cfg.userDir}/Games/brawl.iso";
          };
          Netplay = {
            SelectedHostGame = "Project+ Netplay Launcher.dol";
            BufferSize = cfg.netplay.buffer;
            Nickname = cfg.netplay.nickname;
            MusicOff = cfg.netplay.disableMusic;
            ListenPort = "0x0a42";
            HostPort = "0x0a42";
            ConnectPort = "0x0a42";
            HostCode = 00000000;
            TraversalChoice = "traversal";
          };
          Analytics = {
            Enabled = cfg.analytics.enable;
            PermissionAsked = true;
          };
          Display = {
            Fullscreen = cfg.startFullscreen;
          };
        };
      };
      # Copy dolphin GameSettings configuration from faster-project-plus config
      # This includes various Gecko Code files to make for a better Netplay experience
      "project-plus/GameSettings" = {
        source = "${cfg.userSource}/GameSettings";
        recursive = true;
      };
      "project-plus/Launcher" = {
        source = "${cfg.launcherSource}";
        recursive = true;
      };
      # Cant get this to work, does the sd card need to be writable for dolphin to use it?
      # for now sd card will need to be manually placed in the SD directory
      # "project-plus/Wii/sd.raw" = {
      #   source = cfg.sdCardSource;
      # };
    };
  };
}
