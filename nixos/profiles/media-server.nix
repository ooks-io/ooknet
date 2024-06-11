{ lib, config, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  profiles = config.ooknet.host.profiles;
in

{
  config = mkIf (elem "media-server" profiles) {
    ooknet.services.nixarr.enable = true;
  };
}
