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
    inputs.ookscraft.nixosModules.ookscraft-server
    ./reverse-proxy.nix
  ];
  config = mkIf (elem "minecraft" services) {
    services.ookscraft-server.enable = true;
  };
}
