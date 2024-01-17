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
        capsSysNice = true;
      };
      gamemode = {
        enable = true;
        settings = {
          softrealtime = "auto";
          renice = 15;
        };
      };
    };
    services.pipewire.lowLatency.enable = true;
  };
}
