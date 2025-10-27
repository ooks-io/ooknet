{
  inputs,
  self,
  ...
}: let
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

  ooknetModules = {
    inherit
      isoModules
      nixosCore
      nixosMinimal
      darwinCore
      nixos
      darwin
      common
      core
      hostModules
      nixos-hm
      darwin-hm
      nixosSecrets
      darwinSecrets
      options
      ;
  };
in {
  _module.args.ooknetModules = ooknetModules;
}
