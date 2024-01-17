{ pkgs, lib, config, ... }:

let
  cfg = config.systemModules.user.shell.fish;
in

{
  config = lib.mkIf cfg.enable {
    users.users.ooks.shell = pkgs.fish;
    programs.fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
  };
}
