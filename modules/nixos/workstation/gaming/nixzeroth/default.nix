{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.workstation) profiles;
in {
  imports = [
    inputs.nixzeroth.nixosModules.nixzeroth

    ./world
    ./modules
  ];
  config = mkIf (elem "gaming" profiles) {
    services.nixzeroth = {
      enable = false;
      dev = {
        enable = true;
        sourceTree = "/var/lib/nixzeroth/dev-source";
        repoPath = "/home/${config.ooknet.host.admin.name}/projects/nixzeroth";
      };
      openFirewall = true;
      world = {
        dataDir = "/var/lib/nixzeroth/client-data";
      };
    };

    # nixzeroth CLI without sudo.
    users.users.${config.ooknet.host.admin.name}.extraGroups = ["azerothcore"];
  };
}
