{ osConfig, lib, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  profiles = osConfig.ooknet.host.profiles;
in

{
  config = mkIf (elem "gaming" profiles) {
    ooknet.gaming = {
      wine.enable = true;
      bottles.enable = true;
    };
    ooknet.binds = {
      steam = "steam";
      factorio = "steam steam://rungameid/427520";
    };
  };
}
