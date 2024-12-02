{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet.host) admin;
  inherit (config.ooknet.server) ookflix;
  inherit (config.ooknet.server.ookflix) volumes groups;
  inherit (config.ooknet.server.ookflix.services) jellyfin plex sonarr radarr prowlarr transmission;
  mediaDirPermissions = {
    mode = "0775";
    user = admin.name;
    group = groups.media.name;
  };
  downloadDirPermissions = {
    mode = "0770";
    user = admin.name;
    group = groups.downloads.name;
  };
  ifTheyExist = users: builtins.filter (user: builtins.hasAttr user config.users.users) users;
in {
  config = mkIf ookflix.enable {
    users.groups = {
      ${groups.media.name} = {
        inherit (groups.media) name gid;
        members = ifTheyExist [
          jellyfin.user.name
          plex.user.name
          sonarr.user.name
          radarr.user.name
          prowlarr.user.name
        ];
      };
      ${groups.downloads.name} = {
        inherit (groups.downloads) name gid;
        members = ifTheyExist [
          sonarr.user.name
          radarr.user.name
          prowlarr.user.name
          transmission.user.name
        ];
      };
    };
    systemd.tmpfiles.settings = {
      contentRoot = {
        "${volumes.content.root}"."d" = {
          mode = "0775";
          user = "root";
          group = "root";
        };
      };
      mediaDirectories = {
        "${volumes.media.root}"."d" = mediaDirPermissions;
        "${volumes.media.tv}"."d" = mediaDirPermissions;
        "${volumes.media.movies}"."d" = mediaDirPermissions;
      };
      downloadDirectories = {
        "${volumes.downloads.root}"."d" = downloadDirPermissions;
        "${volumes.downloads.complete}"."d" = downloadDirPermissions;
        "${volumes.downloads.incomplete}"."d" = downloadDirPermissions;
        "${volumes.downloads.watch}"."d" = downloadDirPermissions;
      };
    };
  };
}
