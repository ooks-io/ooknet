{
  lib,
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (lib) singleton recursiveUpdate mkDefault;
  inherit (builtins) concatLists;
  inherit (self) hozen ook;
  inherit (inputs.secrets.nixosModules) secrets;
  hm = inputs.home-manager.nixosModules.home-manager;
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
    (baseModules + "/openssh.nix")
  ];
  core = [baseModules hardwareModules consoleModules appearanceModules hm secrets];
  hostModules = "${self}/hosts";
  installModules = [
    "${nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
    "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
    "${nixpkgs}/nixos/modules/profiles/all-hardware.nix"
  ];

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
            inherit hozen ook lib inputs self inputs' self';
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
    services,
    profile ? null,
    domain ? "",
    additionalModules ? [],
    specialArgs ? {},
  }:
    assert lib.assertMsg (!(type == "vm" && profile == null))
    "Profile must be specified for VM servers";
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
          (
            if type == "vm"
            then [(serverModules + "/profiles/${profile}")]
            else [(hostModules + "/${hostname}")]
          )
          [serverModules]
          additionalModules
        ];
      };

  mkImage = {
    profile ? null,
    system,
    hostname,
    installer ? false,
    additionalModules ? [],
    ...
  }:
    mkNixos {
      specialArgs = {inherit inputs lib self;};
      modules = concatLists [
        (singleton {
          networking.hostName = hostname;
          nixpkgs = {
            hostPlatform = mkDefault system;
            flake.source = nixpkgs.outPath;
          };
        })
        minimalCore
        additionalModules
        [secrets]
        (
          if installer
          then installModules
          else []
        )
        (
          if profile != null
          then ["${self}/modules/server/profiles/${profile}/base"]
          else [(hostModules + "/${hostname}")]
        )
      ];
    };
in {
  inherit mkServer mkWorkstation mkImage;
}
