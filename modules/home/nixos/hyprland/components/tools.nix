{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) attrValues;
  inherit (osConfig.ooknet.workstation) environment;
in {
  config = mkIf (environment == "hyprland") {
    home = {
      packages = attrValues {
        inherit
          (pkgs)
          grim
          slurp
          libnotify
          wl-screenrec
          wf-recorder
          wl-clipboard
          ;
      };
    };

    systemd.user.targets.tray = {
      Unit = {
        Description = "Home Manager System Tray";
        Requires = ["graphical-session-pre.target"];
      };
    };
  };
}
