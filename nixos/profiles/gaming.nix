{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  inherit (config.ooknet.host) profiles;
in {
  config = mkIf (elem "gaming" profiles) {
    ooknet.gaming = {
      steam.enable = true;
      gamescope.enable = true;
      gamemode.enable = true;
    };
    ooknet.services.flatpak.enable = true;
  };
}
