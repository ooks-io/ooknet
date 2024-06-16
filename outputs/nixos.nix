{ inputs, self, withSystem, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;
  inherit (self) keys;

  hm = inputs.home-manager.nixosModules.home-manager;
  nixarr = inputs.nixarr.nixosModules.default;
  agenix = inputs.agenix.nixosModules.default;

  nixosModules = "${self}/nixos";
  hosts = "${self}/hosts";

  specialArgs = {inherit withSystem keys inputs self;};
in

{
  ooksdesk = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [
      "${hosts}/ooksdesk"
      hm
      agenix

      nixosModules
    ];
  };
  ookst480s = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [
      "${hosts}/ookst480s"
      hm
      nixosModules
    ];
  };
  ooksmedia = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [
      "${hosts}/ooksmedia"
      hm
      nixosModules
      nixarr
    ];
  };
  ooksmicro = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [
      "${hosts}/ooksmicro"
      hm
      nixosModules
    ];
  };
  ooksx1 = nixosSystem {
    inherit specialArgs;
    system = "x86_64-linux";
    modules = [
      "${hosts}/ooksx1"
      hm
      nixosModules
    ];
  };
}
