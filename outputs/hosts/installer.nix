{
  withSystem,
  ook,
  ...
}: let
  inherit (ook.lib.builders) mkImage;
in {
  flake.nixosConfigurations = {
    ooksinstall = mkImage {
      inherit withSystem;
      system = "x86_64-linux";
      hostname = "ooksinstall";
      type = "iso";
      role = "installer";
    };
  };
}
