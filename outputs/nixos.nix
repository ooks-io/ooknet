{ inputs, nixpkgs, self, ... }:

let
  inherit (nixpkgs.lib) nixosSystem;

  hm = inputs.home-manager.nixosModules.home-manager;

  systemInputs = "${self}/inputs/system";
  hosts = "${systemInputs}/hosts";
  base = "${systemInputs}/modules/base";

  gaming = "${systemInputs}/modules/roles/gaming";
  workstation = "${systemInputs}/modules/roles/workstation";


  specialArgs = {inherit inputs self;};
in

{
  ooksdesk = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [
      "${hosts}/ooksdesk"
      hm
      base
      gaming
      workstation
    ];
  };
}
