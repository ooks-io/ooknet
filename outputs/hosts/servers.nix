{
  withSystem,
  ook,
  ...
}: let
  inherit (ook.lib.builders) mkServer;
in {
  flake.nixosConfigurations = {
    ooknode = mkServer {
      inherit withSystem;
      system = "x86_64-linux";
      hostname = "ooknode";
      domain = "ooknet.org";
      type = "vm";
      profile = "linode";
      services = ["website" "forgejo"];
    };
    ookmedia = mkServer {
      inherit withSystem;
      system = "x86_64-linux";
      hostname = "ooksmedia";
      domain = "ooknet.org";
      type = "desktop";
      services = ["media-server"];
    };
  };
}
