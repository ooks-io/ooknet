{ lib, config, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  host = config.ooknet.host;
in

{
  config = mkIf (elem "workstation" host.function){
    programs.dconf.enable = true;
  };
}
