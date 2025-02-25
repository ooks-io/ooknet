{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.server) services;
in {
  imports = [inputs.ookscraft.nixosModules.ookscraft-proxy];
  config = mkIf (elem "minecraft-proxy" services) {
    services.ookscraft-proxy = {
      minecraft = {
        enable = true;
        port = 25565;
        endpoint = "ooksmedia.taila3ca6.ts.net";
      };
    };
  };
}
