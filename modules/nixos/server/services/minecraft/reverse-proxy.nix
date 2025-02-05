{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
in {
  config = mkIf (elem "minecraft-proxy" services) {
    services.haproxy = {
      enable = true;
      config = ''
        global
          maxconn 32768
          log stdout format raw local0 info

        defaults
          mode tcp
          log global
          option tcplog
          option dontlognull
          timeout connect 5s
          timeout client 30s
          timeout server 30s

        frontend minecraft_frontend
          bind :25565
          default_backend minecraft_backend

        backend minecraft_backend
          server minecraft ooksmedia.taila3ca6.ts.net:25565 check
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [25565];
      allowedUDPPorts = [25565];
    };
  };
}
