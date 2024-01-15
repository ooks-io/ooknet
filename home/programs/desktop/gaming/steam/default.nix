{ pkgs, config, inputs, lib, ... }:

let
  cfg = programs.desktop.games.steam;
  user = ooks;
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
      home-manager.users.${user} = { config, lib, pkgs, ... }@hm: {
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



