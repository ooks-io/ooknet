{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.systemProfile.gaming;
in

{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  config = lib.mkIf cfg.enable {
    hardware.opengl.extraPackages = [ pkgs.gamescope ];
    programs = {
      steam.enable = true;
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 15;
            softrealtime = "auto";
          };
           custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
    };
    services.pipewire.lowLatency.enable = true;
  };
}
