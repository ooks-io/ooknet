{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.workstation) profiles;
in {
  config = mkIf (elem "gaming" profiles) {
    programs.steam = {
      enable = true;
      package = pkgs.steam-small;
      protontricks.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
  };
}
