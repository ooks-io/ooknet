{
  withSystem,
  ook,
  ...
}: let
  inherit (ook.lib.builders) mkWorkstation;
in {
  flake.nixosConfigurations = {
    ookst480s = mkWorkstation {
      inherit withSystem;
      system = "x86_64-linux";
      hostname = "ookst480s";
      type = "laptop";
    };
    ooksdesk = mkWorkstation {
      inherit withSystem;
      system = "x86_64-linux";
      hostname = "ooksdesk";
      type = "desktop";
    };
  };
}
