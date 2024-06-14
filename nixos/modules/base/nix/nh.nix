{ pkgs, lib, config, ... }: 

let
  inherit (lib) mkIf;
  host = config.ooknet.host;
  admin = host.admin;
in

{
  config = mkIf (host.type != "phone") {
    environment.variables.FLAKE = mkIf admin.homeManager "/home/${admin.name}/.config/ooknet/";

    programs.nh = {
      enable = true;
      package = pkgs.nh;
    };
  };
}
