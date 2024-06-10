{ config, ... }:

let
  cfg = config.ooknet.host;
in

{
  config = {
    networking.hostName = cfg.name;
    environment.sessionVariables.HN = cfg.name;
  };
}
