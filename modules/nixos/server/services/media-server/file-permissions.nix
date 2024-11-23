{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.server) media-server;
  inherit (config.ooknet.server.media-server) storage groups users;

  contentPermissions = {
    group = groups.media;
    user = "root";
    mode = "0775";
  };

  downloadPermissions = {
    group = groups.media;
    user = users.downloader;
    mode = "0775";
  };
in {
  config = mkIf media-server.enable {
    systemd.tmpfiles.settings = {
      content-dirs = {
        "${storage.content.root}"."d" = contentPermissions;
        "${storage.content.movies}"."d" = contentPermissions;
        "${storage.content.tv}"."d" = contentPermissions;
        "${storage.content.music}"."d" = contentPermissions;
        "${storage.content.books}"."d" = contentPermissions;
      };
      download-dirs = {
        "${storage.downloads.root}"."d" = downloadPermissions;
        "${storage.downloads.incomplete}"."d" = downloadPermissions;
        "${storage.downloads.watch}"."d" = downloadPermissions;
        "${storage.downloads.manual}"."d" = downloadPermissions;
        "${storage.downloads.radarr}"."d" = downloadPermissions;
        "${storage.downloads.sonarr}"."d" = downloadPermissions;
        "${storage.downloads.readarr}"."d" = downloadPermissions;
      };
    };
  };
}
