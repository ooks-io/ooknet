{
  config,
  lib,
  ...
}: let
  inherit (lib) elem mkIf;
  inherit (config.ooknet.server) services;
in {
  config = mkIf (elem "media-server" services) {
    users = {
      groups = {
        downloader = {};
        media = {};
      };
      users = {
        downloader = {
          isSystemUser = true;
          group = "downloader";
        };
      };
    };
  };
}
