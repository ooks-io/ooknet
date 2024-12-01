{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkMerge;
  inherit (builtins) mapAttrs;
  inherit (config.ooknet.server) ookflix;
  inherit (config.ooknet.server.ookflix) services storage users groups;

  mkServiceUser = name: user: {
    isSystemUser = true;
    group = groups.${name}.name;
    uid = users.${name}.id;
    home = storage.state.${name};
  };

  generateUsers = mapAttrs mkServiceUser users;
in {
  config = mkIf ookflix.enable {
    users = {
      users = mkMerge [
        # media service users
        (mkIf services.jellyfin.enable {
          ${users.jellyfin.name} = mkServiceUser users.jellyfin.name groups.media.name;
        })
        (mkIf services.plex.enable {
          ${users.plex.name} = mkServiceUser users.plex.name groups.media.name;
        })
        (mkIf (services.jellyfin.enable || services.jellyseer.enable) {
          ${users.jellyseer.name} = mkServiceUser users.jellyseer.name groups.media.name;
        })
      ];
      groups = {
      };
    };
  };
}
