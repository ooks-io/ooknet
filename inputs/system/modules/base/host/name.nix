{ lib, config, ... }:

let
  inherit (lib) types mkOption;
  cfg = config.systemModules.host;
in

{
  options.systemModules.host = {
    name = mkOption {
      type = types.str;
      default = "ooksgeneric";
      description = "Name of host machine";
    };
  };

  config = {
    networking.hostName = cfg.name;
    environment.sessionVariables.HN = cfg.name;
  };
}
