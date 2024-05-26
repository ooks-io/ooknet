{ pkgs, lib, config, ... }: 

let
  inherit (lib) mkIf;
  host = config.systemModules.host;
in

{
  config = mkIf (host.type != "phone") {
  # TODO: i dont't want to hardcode this.
    environment.variables.FLAKE = "/home/ooks/.config/ooknix/";

    programs.nh = {
      enable = true;
      package = pkgs.nh;
    };
  };
}
