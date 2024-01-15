{ pkgs, config, inputs, lib, ... }:

let
  cfg = config.programs.desktop.games.steam;
in

{
  config = lib.mkIf cfg.enable {
    hardware.opengl.extraPackages = [ pkgs.gamescope ];
    hardware.opengl.driSupport32Bit = true;
    programs = {
      steam = {
        enable = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      gamemode = {
        enable = true;
        enableRenice = true;
      };
      home-manager.users.ooks = { config, lib, pkgs, ... }: {
        home.packages = with pkgs; [
          protonup-ng
        ];
        programs = {
          mangohud = {
            enable = true;
          };
        };
      };
    };
  };
}



