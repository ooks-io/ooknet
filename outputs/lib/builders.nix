{
  lib,
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (lib) singleton recursiveUpdate mkDefault;
  inherit (builtins) concatLists;
  inherit (self) hozen keys;
  hm = inputs.home-manager.nixosModules.home-manager;
  agenix = inputs.agenix.nixosModules.default;
  nixosModules = "${self}/modules/nixos";
  baseModules = nixosModules + "/base";
  hardwareModules = nixosModules + "/hardware";
  appearanceModules = nixosModules + "/appearance";
  consoleModules = nixosModules + "/console";
  workstationModules = nixosModules + "/workstation";
  serverModules = nixosModules + "/server";
  minimalCore = [
    (baseModules + "/options.nix")
    (baseModules + "/admin.nix")
    (baseModules + "/ssh.nix")
  ];
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
            inherit hozen keys lib inputs self inputs' self';
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
        [(hostModules + "/${hostname}")]
        [workstationModules]
        additionalModules
      ];
    };

  mkServer = {
    withSystem,
    hostname,
    system,
    type,
    profile,
    services,
    domain ? "",
    additionalModules ? [],
    specialArgs ? {},
  }:
    mkBaseSystem {
      inherit withSystem hostname system type specialArgs;
      role = "server";
      additionalModules = concatLists [
        (singleton {
          ooknet.server = {
            inherit domain services;
          };
        })
        core
        [(serverModules + "/profiles/${profile}")]
        [serverModules]
        additionalModules
      ];
    };

  mkImage = {
    profile,
    system,
    hostname,
    additionalModules ? [],
    ...
  }:
    mkNixos {
      specialArgs = {inherit keys inputs lib self;};
      modules = concatLists [
        (singleton {
          networking.hostName = hostname;
          nixpkgs = {
            hostPlatform = mkDefault system;
            flake.source = nixpkgs.outPath;
          };
        })
        ["${self}/modules/server/profiles/${profile}/base"]
        minimalCore
        additionalModules
      ];
    };
in {
  inherit mkServer mkWorkstation mkImage;
}
