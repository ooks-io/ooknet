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
    ./networking.nix
    ./security.nix
    ./packages.nix
    ./fonts.nix
    ./environment
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
