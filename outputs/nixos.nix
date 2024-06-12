{ inputs, self, ... }:

let
  inherit (inputs.nixpkgs.lib) nixosSystem;

  hm = inputs.home-manager.nixosModules.home-manager;

  nixosModules = "${self}/nixos";
  hosts = "${self}/hosts";

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
  };
}
