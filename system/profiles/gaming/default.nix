{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.systemProfile.gaming;
  steamFix = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [
      xorg.libXcursor
      xorg.libXi
      xorg.libXinerama
      xorg.libXScrnSaver
      libpng
      libpulseaudio
      libvorbis
      stdenv.cc.cc.lib
      libkrb5
      keyutils
      mangohud
      winetricks
      protontricks
    ];
  };
in

{
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  config = lib.mkIf cfg.enable {
    hardware.opengl.extraPackages = [ pkgs.gamescope ];
    programs = {
      steam = {
        enable = true;
        package = steamFix;
      };
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
