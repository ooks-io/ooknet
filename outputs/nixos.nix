{
  self,
  withSystem,
  ooknet,
  ...
}: let
  inherit (ooknet.lib.builders) mkServer mkWorkstation;
in {
  flake.nixosConfigurations = {
    ooksdesk = mkWorkstation {
      inherit withSystem;
      hostname = "ooksdesk";
      system = "x86_64-linux";
      type = "desktop";
    };

    ookst480s = mkWorkstation {
      inherit withSystem;
      system = "x86_64-linux";
      hostname = "ookst480s";
      type = "laptop";
    };

    ooksmedia = mkWorkstation {
      inherit withSystem;
      system = "x86_64-linux";
      hostname = "ooksmedia";
      type = "desktop";
    };

    ooksmicro = mkWorkstation {
      inherit withSystem;
      system = "x86_64-linux";
      hostname = "ooksmicro";
    };

    ooksx1 = mkWorkstation {
      inherit withSystem;
      system = "x86_64-linux";
      hostname = "ooksx1";
    };
    ooknode = mkServer {
      inherit withSystem;
      system = "x86_64-linux";
      hostname = "ooknode";
    };
  };
}
