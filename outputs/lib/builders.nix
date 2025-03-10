{
  lib,
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (lib) assertMsg singleton recursiveUpdate mkDefault;
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
  imageModules = nixosModules + "/image";

  minimalCore = [
    (baseModules + "/options.nix")
    (baseModules + "/admin.nix")
    (baseModules + "/openssh.nix")
  ];
  core = [baseModules hardwareModules consoleModules appearanceModules hm secrets];
  hostModules = "${self}/hosts";
  isoModules = [
    secrets
    (imageModules + "/isoImage.nix")
    (baseModules + "/networking.nix")
    (baseModules + "/nix.nix")
    (baseModules + "/tailscale.nix")
    (baseModules + "/security/sudo.nix")
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
    assert assertMsg (!(type == "vm" && profile == null))
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
    withSystem,
    profile ? null,
    hostname,
    system,
    type,
    role,
    additionalModules ? [],
    specialArgs ? {},
  }:
    mkBaseSystem {
      inherit withSystem role hostname system type specialArgs;
      additionalModules = concatLists [
        minimalCore
        additionalModules
        (
          if type == "iso"
          then isoModules
          else []
        )
        (
          if role == "installer"
          then [(imageModules + "/installer.nix")]
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
