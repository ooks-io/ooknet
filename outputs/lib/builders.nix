{
  lib,
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (lib) singleton recursiveUpdate mkDefault;
  inherit (builtins) concatLists;
  inherit (self) keys;
  hm = inputs.home-manager.nixosModules.home-manager;
  agenix = inputs.agenix.nixosModules.default;
  nixosModules = "${self}/modules/nixos";
  baseModules = nixosModules + "/base";
  hardwareModules = nixosModules + "/hardware";
  appearanceModules = nixosModules + "/appearance";
  consoleModules = nixosModules + "/console";
  workstationModules = nixosModules + "/workstation";
  serverModules = nixosModules + "/server";
  core = [baseModules hardwareModules consoleModules appearanceModules hm agenix];
  hostModules = "${self}/hosts";

  mkNixos = nixpkgs.lib.nixosSystem;

  mkBaseSystem = {
    withSystem,
    hostname,
    system,
    type,
    role,
    additionalModules ? [],
    specialArgs ? {},
  }:
    withSystem system ({
      inputs',
      self',
      ...
    }:
      mkNixos {
        specialArgs =
          recursiveUpdate {
            inherit keys lib inputs self inputs' self';
          }
          specialArgs;
        modules = concatLists [
          (singleton {
            networking.hostName = hostname;
            nixpkgs = {
              flake.source = nixpkgs.outPath;
              hostPlatform = mkDefault system;
            };
            ooknet.host = {
              name = hostname;
              inherit role type;
            };
          })
          [(hostModules + "/${hostname}")]
          additionalModules
        ];
      });

  mkWorkstation = {
    withSystem,
    hostname,
    system,
    type,
    additionalModules ? [],
    specialArgs ? {},
  }:
    mkBaseSystem {
      inherit withSystem hostname system type specialArgs;
      role = "workstation";
      additionalModules = concatLists [
        core
        [workstationModules]
        additionalModules
      ];
    };

  mkServer = {
    withSystem,
    hostname,
    system,
    type,
    platform,
    services,
    additionalModules ? [],
    specialArgs ? {},
  }:
    mkBaseSystem {
      inherit withSystem hostname system type specialArgs;
      role = "server";
      additionalModules = concatLists [
        (singleton {
          ooknet.host = {
            inherit platform services;
          };
        })
        core
        [serverModules]
        additionalModules
      ];
    };
in {
  inherit mkServer mkWorkstation;
}
