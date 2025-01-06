{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config.ooknet.hardware) features;
in {
  config = mkIf (elem "printing" features) {
    services = {
      printing = {
        enable = true;
        drivers = [
          pkgs.hplip
          # FIXME: pkgs.cnijfilter2
        ];
      };
      avahi = {
        enable = true;
        openFirewall = true;
        nssmdns4 = true;
      };
    };
  };
}
