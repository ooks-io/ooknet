{self, ...}: let
  inherit (self.lib) mkWorkstation;
in {
  flake.nixosConfigurations = {
    grookin = mkWorkstation {
      hostname = "grookin";
      system = "x86-64-linux";
    };
  };
}
