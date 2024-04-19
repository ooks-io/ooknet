{ pkgs, lib, config, ... }: 

let
  cfg = config.systemModules.nixOptions;
  inherit (lib) mkIf;
in

{
  config = mkIf cfg.enable {
    environment.variables.FLAKE = "/home/ooks/.config/ooknix/";

    programs.nh = {
      enable = true;
      package = pkgs.nh;
      clean = {
        enable = true;
        extraArgs = "--keep-since 30d";
      };
    };
  };
}
