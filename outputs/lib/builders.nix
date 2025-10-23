{
  lib,
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixpkgs;
  inherit (lib) assertMsg singleton mkDefault;
  inherit (builtins) concatLists;
  inherit (self) hozen ook;
  inherit (inputs.secrets.nixosModules) nixosSecrets;
  inherit (inputs.secrets.nixosModules) darwinSecrets;
  inherit (inputs.disko.nixosModules) disko;

  nixosModules = "${self}/modules/nixos";
  commonModules = "${self}/modules/common";
  hostModules = "${self}/hosts";
  options = "${self}/modules/options";

  nixos-hm = inputs.home-manager.nixosModules.home-manager;
  darwin-hm = inputs.home-manager.darwinModules.home-manager;

  nixos = {
    base = nixosModules + "/base";
    hardware = nixosModules + "/hardware";
    server = nixosModules + "/server";
    image = nixosModules + "/image";
    workstation = nixosModules + "/workstation";
    virtualization = nixosModules + "/virtualization";
  };
  common = {
    base = commonModules + "/base";
    workstation = commonModules + "/workstation";
    console = commonModules + "/console";
  };
  darwin = "${self}/modules/darwin";

  nixosMinimal = [
    options
    (common.base + "/admin.nix")
    (nixos.base + "/openssh.nix")
  ];

  core = [
    options
    common.base
    common.console
  ];

  nixosCore =
    core
    ++ [
      nixos.base
      nixos.hardware
      nixos.virtualization
      nixos-hm
      nixosSecrets
      disko
    ];

  darwinCore =
    core
    ++ [
      darwin
      darwin-hm
      darwinSecrets
    ];

  isoModules = [
    nixosSecrets
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
        specialArgs = {
          inherit hozen ook inputs self inputs' self';
        };
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
          then darwinCore ++ [common.workstation]
          else nixosCore ++ [nixos.workstation common.workstation];
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
            then [(hostModules + "/${profile}")]
            else [(hostModules + "/${hostname}")]
          )
          [nixos.server]
          additionalModules
        ];
      };

  mkImage = {
    withSystem,
    hostname,
    system,
    profile ? null,
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
          then [(hostModules + "/${profile}")]
          else [(hostModules + "/${hostname}")]
        )
      ];
    };
in {
  inherit mkServer mkWorkstation mkImage;
}
