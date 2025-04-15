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
  inherit (inputs.home-manager.nixosModules) home-manager;

  nixosModules = "${self}/modules/nixos";
  commonModules = "${self}/modules/common";
  hostModules = "${self}/hosts";

  nixos = {
    base = nixosModules + "/base";
    hardware = nixosModules + "/hardware";
    server = nixosModules + "/server";
    image = nixosModules + "/image";
    workstation = nixosModules + "/workstation";
  };
  common = {
    base = commonModules + "/base";
    appearance = commonModules + "/appearance";
    console = commonModules + "/console";
  };
  darwin = "${self}/modules/darwin";

  nixosMinimal = [
    (common.base + "/options.nix")
    (common.base + "/admin.nix")
    (nixos.base + "/openssh.nix")
  ];

  core = [
    common.base
    common.appearance
    common.console
    secrets
    home-manager
  ];

  nixosCore =
    core
    ++ [
      nixos.base
      nixos.hardware
    ];

  darwinCore =
    core
    ++ [
      darwin

      # TODO: this is jank please make better... actually this whole thing is jank
      (nixos.workstaion + "options.nix")
    ];

  isoModules = [
    secrets
    (nixos.image + "/isoImage.nix")
    (nixos.base + "/networking.nix")
    (nixos.base + "/tailscale.nix")
    (common.base + "/nix.nix")
    (common.base + "/sudo.nix")
  ];

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
    }: let
      mkSystem =
        if system == "aarch64-darwin"
        then inputs.nix-darwin.lib.darwinSystem
        else nixpkgs.lib.nixosSystem;
    in
      mkSystem {
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
      additionalModules = let
        platformModules =
          if (system == "aarch64-darwin")
          then darwinCore
          else nixosCore ++ [nixos.workstation];
      in
        concatLists [
          platformModules
          [(hostModules + "/${hostname}")]
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
          nixosCore
          (
            if type == "vm"
            then [(nixos.server + "/profiles/${profile}")]
            else [(hostModules + "/${hostname}")]
          )
          [nixos.server]
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
        nixosMinimal
        additionalModules
        (
          if type == "iso"
          then isoModules
          else []
        )
        (
          if role == "installer"
          then [(nixos.image + "/installer.nix")]
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
