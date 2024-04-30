{ lib, config, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  host = config.systemModules.host;
in

{
  config = mkIf (elem "workstation" host.function) {
    programs.bandwhich.enable = true;
  };
}
