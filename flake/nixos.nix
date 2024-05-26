{ inputs, nixpkgs, self, ... }:

let
  inherit (nixpkgs.lib) nixosSystem;

  hm = inputs.home-manager.nixosModules.home-manager;

  systemInputs = "${self}/sys";
  hosts = "${systemInputs}/hosts";
  base = "${systemInputs}/modules/base";

  roles = "${systemInputs}/modules/roles";
  gaming = "${roles}/gaming";
  workstation = "${roles}/workstation";
  media-server = "${roles}/media-server";



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
  ookst480s = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [
      "${hosts}/ookst480s"
      hm
      base

      workstation
    ];
  };
  ooksmedia = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [
      "${hosts}/ooksmedia"
      hm
      base

      gaming
      workstation
      media-server
    ];
  };
}