{
  config,
  lib,
  withSystem,
  inputs,
  self,
  ooknetModules,
  ...
}: let
  inherit (lib) mapAttrs mkDefault singleton assertMsg;
  inherit (builtins) concatLists;
  inherit (self) hozen ook;
  inherit (ooknetModules) nixosCore nixos hostModules;

  buildServer = hostname: cfg:
    assert assertMsg (!(cfg.type == "vm" && cfg.profile == null))
    "Profile must be specified for VM servers (${hostname})";
      withSystem cfg.system ({
        inputs',
        self',
        ...
      }:
        inputs.nixpkgs.lib.nixosSystem {
          specialArgs =
            {
              inherit hozen ook inputs self inputs' self';
            }
            // cfg.additionalArgs;

          modules = concatLists [
            (singleton {
              networking.hostName = hostname;
              nixpkgs = {
                flake.source = inputs.nixpkgs.outPath;
                hostPlatform = mkDefault cfg.system;
              };
              ooknet.host = {
                name = hostname;
                role = "server";
                type = cfg.type;
              };
              ooknet.server = {
                inherit (cfg) domain services;
              };
            })
            nixosCore
            [nixos.server]
            (
              if cfg.type == "vm"
              then [(hostModules + "/${cfg.profile}")]
              else [(hostModules + "/${hostname}")]
            )
            cfg.additionalModules
          ];
        });
in {
  config.flake.nixosConfigurations = mapAttrs buildServer config.flake.ooknet.servers;
}
