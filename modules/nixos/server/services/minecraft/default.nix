{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) elem mkIf;
  inherit (config.ooknet.server) services;
in {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./reverse-proxy.nix
  ];
  config = mkIf (elem "minecraft" services) {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      servers.ookscraft = {
        enable = true;
        openFirewall = true;
        autoStart = true;

        serverProperties = {
          openFirewall = true;
          motd = "ook ook";
          server-port = 25565;
          difficulty = "hard";
          gamemode = "survival";
          online-mode = true;
          enable-rcon = true;
          "rcon.password" = "ooksmoneymoves";
          view-distance = 8;
          simulation-distance = 8;
          allow-flight = true;
        };
      };
    };
  };
}
