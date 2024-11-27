{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) path port str lines;
  inherit (config.ooknet) server;
  cfg = server.media-server;

  mkSubdomain = name:
    mkOption {
      type = str;
      default = "${name}.${server.domain}";
    };

  mkProxy = port: ''
    encode zstd gzip
    reverse_proxy localhost:${toString port} {
      header_up X-Real-IP {remote_host}
      header_up X-Forwarded-For {remote_host}
      header_up X-Forwarded-Proto {scheme}
    }
  '';
in {
  options.ooknet.server.media-server = {
    enable = mkEnableOption "Enable media server functionality";

    jellyfin.enable = mkEnableOption "Enable the Jellyfin module";
    plex.enable = mkEnableOption "Enable Plex module";
    transmission.enable = mkEnableOption "Enable Transmission module";
    radarr.enable = mkEnableOption "Enable Radarr module";
    sonarr.enable = mkEnableOption "Enable Sonarr module";
    prowlarr.enable = mkEnableOption "Enable Sonarr module";

    storage = {
      mediaRoot = mkOption {
        type = path;
        default = "/jellyfin";
        description = "Root directory for all media-related storage";
      };

      content = {
        root = mkOption {
          type = path;
          default = "${cfg.storage.mediaRoot}/content";
          description = "Root directory for media content";
        };
        movies = mkOption {
          type = path;
          default = "${cfg.storage.content.root}/movies";
        };
        tv = mkOption {
          type = path;
          default = "${cfg.storage.content.root}/tv";
        };
        music = mkOption {
          type = path;
          default = "${cfg.storage.content.root}/music";
        };
        books = mkOption {
          type = path;
          default = "${cfg.storage.content.root}/books";
        };
      };

      downloads = {
        root = mkOption {
          type = path;
          default = "${cfg.storage.mediaRoot}/downloads";
        };
        incomplete = mkOption {
          type = path;
          default = "${cfg.storage.downloads.root}/.incomplete";
        };
        watch = mkOption {
          type = path;
          default = "${cfg.storage.downloads.root}/.watch";
        };
        manual = mkOption {
          type = path;
          default = "${cfg.storage.downloads.root}/manual";
        };
        radarr = mkOption {
          type = path;
          default = "${cfg.storage.downloads.root}/radarr";
        };
        sonarr = mkOption {
          type = path;
          default = "${cfg.storage.downloads.root}/sonarr";
        };
        readarr = mkOption {
          type = path;
          default = "${cfg.storage.downloads.root}/readarr";
        };
      };

      state = {
        root = mkOption {
          type = path;
          default = "/var/lib";
          description = "Root directory for service state";
        };
        jellyfin = mkOption {
          type = path;
          default = "${cfg.storage.state.root}/jellyfin";
        };
        plex = mkOption {
          type = path;
          default = "${cfg.storage.state.root}/plex";
        };
        sonarr = mkOption {
          type = path;
          default = "${cfg.storage.state.root}/sonarr";
        };
        radarr = mkOption {
          type = path;
          default = "${cfg.storage.state.root}/radarr";
        };
        transmission = mkOption {
          type = path;
          default = "${cfg.storage.state.root}/transmission";
        };
      };
    };

    groups = {
      media = mkOption {
        type = str;
        default = "media";
      };
      prowlarr = mkOption {
        type = str;
        default = "prowlarr";
      };
      radarr = mkOption {
        type = str;
        default = "radarr";
      };
    };

    users = {
      jellyfin = mkOption {
        type = str;
        default = "jellyfin";
      };
      plex = mkOption {
        type = str;
        default = "plex";
      };
      sonarr = mkOption {
        type = str;
        default = "sonarr";
      };
      transmission = mkOption {
        type = str;
        default = "transmission";
      };
      prowlarr = mkOption {
        type = str;
        default = "prowlarr";
      };
      downloader = mkOption {
        type = str;
        default = "downloader";
      };
      streamer = mkOption {
        type = str;
        default = "streamer";
      };
    };

    ports = {
      jellyfin = mkOption {
        type = port;
        default = 8096;
      };
      plex = mkOption {
        type = port;
        default = 32400;
      };
      transmission = {
        web = mkOption {
          type = port;
          default = 9091;
        };
        peer = mkOption {
          type = port;
          default = 50000;
        };
      };
      sonarr = mkOption {
        type = port;
        default = 8989;
      };
      radarr = mkOption {
        type = port;
        default = 7878;
      };
      prowlarr = mkOption {
        type = port;
        default = 9696;
      };
    };

    domain = {
      jellyfin = mkSubdomain "jellyfin";
      plex = mkSubdomain "plex";
      transmission = mkSubdomain "transmission";
      sonarr = mkSubdomain "sonarr";
      radarr = mkSubdomain "radarr";
      prowlarr = mkSubdomain "prowlarr";
    };

    proxy = {
      jellyfin = mkOption {
        type = lines;
        default = mkProxy cfg.ports.jellyfin;
      };
      plex = mkOption {
        type = lines;
        default = mkProxy cfg.ports.plex;
      };
      sonarr = mkOption {
        type = lines;
        default = mkProxy cfg.ports.sonarr;
      };
      radarr = mkOption {
        type = lines;
        default = mkProxy cfg.ports.radarr;
      };
      prowlarr = mkOption {
        type = lines;
        default = mkProxy cfg.ports.prowlarr;
      };
      transmission = mkOption {
        type = lines;
        default = mkProxy cfg.ports.transmission.web;
      };
    };
  };
}
