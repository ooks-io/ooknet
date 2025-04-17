{
  withSystem,
  ook,
  ...
}: let
  inherit (ook.lib.builders) mkWorkstation mkDarwin;
in {
  flake = {
    nixosConfigurations = {
      ookst480s = mkWorkstation {
        inherit withSystem;
        system = "x86_64-linux";
        hostname = "ookst480s";
        type = "laptop";
      };
      ooksmicro = mkWorkstation {
        inherit withSystem;
        system = "x86_64-linux";
        hostname = "ooksmicro";
        type = "laptop";
      };
      ooksx1 = mkWorkstation {
        inherit withSystem;
        system = "x86_64-linux";
        hostname = "ooksx1";
        type = "laptop";
      };
      ooksdesk = mkWorkstation {
        inherit withSystem;
        system = "x86_64-linux";
        hostname = "ooksdesk";
        type = "desktop";
      };
    };
    darwinConfigurations = {
      ooksair = mkWorkstation {
        inherit withSystem;
        system = "aarch64-darwin";
        hostname = "ooksair";
        type = "laptop";
      };
    };
  };
}
