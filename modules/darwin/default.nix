{
  lib,
  config,
  self,
  ...
}: let
  inherit (lib) optionalAttrs;
  inherit (config.ooknet.host) admin guest;
in {
  imports = [
    ./system.nix
  ];
  home-manager.users =
    (optionalAttrs admin.homeManager {
      "${admin.name}" = {
        imports = ["${self}/modules/home/common"];
      };
    })
    // (optionalAttrs guest.homeManager {
      "${guest.name}" = {
        imports = ["${self}/modules/home/common"];
      };
    });
}
