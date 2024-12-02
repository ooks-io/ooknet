{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) admin;
  inherit (config.ooknet.server) ookflix;
  inherit (config.ooknet.server.ookflix) volumes groups;
  inherit (config.ooknet.server.ookflix.services) jellyfin plex sonarr radarr prowlarr qbittorrent;
  dataDirPermissions = {
    mode = "0775";
    user = admin.name;
    group = groups.media.name;
  };
  ifTheyExist = users: builtins.filter (user: builtins.hasAttr user config.users.users) users;
in {
  config = mkIf ookflix.enable {
    users.groups = {
      ${groups.media.name} = {
        inherit (groups.media) name;
        gid = groups.media.id;
        members = ifTheyExist [
          # need access to the media library
          jellyfin.user.name
          plex.user.name

          # need access to the media library and the torrent/usenet library
          sonarr.user.name
          radarr.user.name
          prowlarr.user.name

          # need access to the torrent library
          qbittorrent.user.name
        ];
      };
    };
    systemd.tmpfiles.settings = {
      ookflixDataDirs = {
        /*
        set up the entire directory structure it should look something like this:
        data
        ├── torrents
        │  ├── movies
        │  ├── books
        │  └── tv
        ├── usenet
        │   ├── incomplete
        │   └── complete
        │       ├── books
        │       ├── movies
        │       └── tv
        └── media
            ├── movies
            ├── books
            └── tv
        */
        "${volumes.data.root}"."d" = dataDirPermissions;
        "${volumes.torrents.root}"."d" = dataDirPermissions;
        "${volumes.torrents.movies}"."d" = dataDirPermissions;
        "${volumes.torrents.tv}"."d" = dataDirPermissions;
        "${volumes.torrents.books}"."d" = dataDirPermissions;
        "${volumes.usenet.root}"."d" = dataDirPermissions;
        "${volumes.usenet.incomplete}"."d" = dataDirPermissions;
        "${volumes.usenet.complete.root}"."d" = dataDirPermissions;
        "${volumes.usenet.complete.movies}"."d" = dataDirPermissions;
        "${volumes.usenet.complete.tv}"."d" = dataDirPermissions;
        "${volumes.usenet.complete.books}"."d" = dataDirPermissions;
        "${volumes.media.root}"."d" = dataDirPermissions;
        "${volumes.media.movies}"."d" = dataDirPermissions;
        "${volumes.media.tv}"."d" = dataDirPermissions;
        "${volumes.media.books}"."d" = dataDirPermissions;
      };
    };
  };
}
