{ pkgs, lib, config, ... }:

let
  inherit (lib) mkIf;
  userShell = config.systemModules.user.shell;
in

{
  config = mkIf (userShell == "fish") {
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
