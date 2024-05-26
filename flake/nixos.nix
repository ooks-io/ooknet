{ inputs, self, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  hm = inputs.home-manager.nixosModules.home-manager;

  sys = "${self}/sys";
  hosts = "${self}/hosts";

  base = "${sys}/modules/base";
  roles = "${sys}/modules/roles";
  gaming = "${roles}/gaming";
  workstation = "${roles}/workstation";
  media-server = "${roles}/media-server";



  specialArgs = {inherit inputs self;};
in

{
  flake.nixosConfigurations = {
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
  };
}
