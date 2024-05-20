{ inputs, nixpkgs, self, ... }:

let
  inherit (nixpkgs.lib) nixosSystem;

  hm = inputs.home-manager.nixosModules.home-manager;

  systemInputs = "${self}/inputs/system";
  hosts = "${systemInputs}/hosts";
  base = "${systemInputs}/modules/base";

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
    ];
  };
}
