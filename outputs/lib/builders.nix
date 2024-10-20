{
  lib,
  inputs,
  self,
  ...
}: let
  inherit (lib) singleton recursiveUpdate mkDefault;
  inherit (builtins) concatLists;
  inherit (self) keys;
  hm = inputs.home-manager.nixosModules.home-manager;
  agenix = inputs.agenix.nixosModules.default;
  nixosModules = "${self}/nixos";
  mkNixos = inputs.nixpkgs.lib.nixosSystem;
  hostModules = "${self}/hosts";

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
            nixpkgs.hostPlatform = mkDefault system;
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
        [hm agenix nixosModules]
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
        additionalModules
      ];
    };
in {
  inherit mkServer mkWorkstation;
}
