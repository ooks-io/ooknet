{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) concatStringsSep;
  inherit (config.ooknet.server) media-server;
  inherit (config.ooknet.server.media-server) storage ports users groups domain proxy;
in {
  config = mkIf media-server.transmission.enable {
    services.transmission = {
      enable = true;
      package = pkgs.transmission_4;

      # systemd service permissions
      user = users.downloader;
      group = groups.media;

      # location of transmission config dir
      home = storage.state.transmission;

      # web ui
      webHome = pkgs.flood-for-transmission;

      # additional configurations
      # see <https://github.com/transmission/transmission/blob/main/docs/Editing-Configuration-Files.md>
      settings = {
        # enable in completed directory
        # this is where files will be placed while still being downloaded
        incomplete-dir-enabled = true;

        # enable the watch directory
        # this will look for any new torrent files and start downloading them
        watch-dir-enabled = true;

        # location of the main download directories
        download-dir = storage.downloads.root;
        incomplete-dir = storage.downloads.incomplete;
        watch-dir = storage.downloads.watch;

        # rpc settings
        # rpc is how we connect to the service remotely
        rpc-port = ports.transmission.web;

        # what ip addresses are allowed to connect through rpc
        rpc-whitelist-enabled = true;
        rpc-whitelist = concatStringsSep "," [
          # localhost
          "127.0.0.1"
          # generic home networks
          "192.168.*"
          "10.*"
        ];

        # basic anti bruteforce protection
        anti-brute-force-enabled = true;

        # how many authentication attempts can be made before the rpc server will deny any further
        # authentication attempts.
        anti-brute-force-threshold = 10;

        peer-port = ports.transmission.peer;
        port-forwarding-enabled = false;

        # private trackers usually require disabling these
        utp-enabled = false;
        dht-enabled = false;
        pex-enabled = false;
        lpd-enabled = false;
      };
    };
    ooknet.server.webserver.caddy.enable = true;
    services.caddy.virtualHosts."${domain.transmission}".extraConfig = proxy.transmission;
  };
}
