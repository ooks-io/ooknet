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
          wl-clipboard
          ;
        # broken against ffmpeg 9, drop override once nixpkgs #552231 hits unstable
        wf-recorder = pkgs.wf-recorder.override {ffmpeg = pkgs.ffmpeg_8;};
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
