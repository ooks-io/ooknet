{ inputs, self, withSystem, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) keys;

  hosts = "${self}/hosts";

  hm = inputs.home-manager.nixosModules.home-manager;
  nixarr = inputs.nixarr.nixosModules.default;
  agenix = inputs.agenix.nixosModules.default;

  nixosModules = "${self}/nixos";

  workstation = [
    hm
    agenix
    nixosModules
  ];

  specialArgs = {inherit withSystem keys inputs self;};
in

{
  ooksdesk = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [ "${hosts}/ooksdesk" ] ++ workstation;
  };

  ookst480s = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [ "${hosts}/ookst480s" ] ++ workstation;
  };

  ooksmedia = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [ "${hosts}/ooksmedia" nixarr ] ++ workstation;
  };

  ooksmicro = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [ "${hosts}/ooksmicro" ] ++ workstation;
  };

  ooksx1 = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [ "${hosts}/ooksx1" ] ++ workstation;
  };
}
