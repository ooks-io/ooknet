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
      type = "vm";
      profile = "linode";
      services = ["website"];
    };
  };
}
