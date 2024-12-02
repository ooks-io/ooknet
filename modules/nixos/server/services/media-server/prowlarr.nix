{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe;
  inherit (config.ooknet.server) media-server;
  inherit (config.ooknet.server.media-server) storage users groups domain proxy ports;
in {
  config = mkIf media-server.prowlarr.enable {
    # we dont use the nixpkgs prowlarr service module because it lacks the option to
    # declare dataDir, user and group.

    # setup user
    users.users.prowlarr = {
      group = groups.prowlarr;
      home = storage.state.prowlarr;
      uid = 293;
      isSystemUser = true;
    };
    users.groups.prowlarr = {};

    # basic systemd service
    systemd = {
      services.prowlarr = {
        description = "Prowlarr";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          Type = "simple";
          User = users.prowlarr;
          group = groups.prowlarr;
          ExecStart = "${getExe pkgs.prowlarr} -nobrowser -data=${storage.state.prowlarr}";
          Restart = "on-failure";
        };
      };
      tmpfiles.settings.prowlarrDirs = {
        "${storage.state.prowlarr}"."d" = {
          mode = "0700";
          user = users.prowlarr;
          group = groups.prowlarr;
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ports.prowlarr];
    ooknet.server.webserver.caddy.enable = true;
    services.caddy.virtualHosts."${domain.prowlarr}".extraConfig = proxy.prowlarr;
  };
}
