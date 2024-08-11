{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.ooknet) host;
  inherit (host) admin;
in {
  config = mkIf (host.type != "phone") {
    environment.variables.FLAKE = mkIf admin.homeManager "/home/${admin.name}/.config/ooknet/";

    programs.nh = {
      enable = true;
      package = pkgs.nh;
    };
  };
}
