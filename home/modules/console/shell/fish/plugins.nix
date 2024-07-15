{ lib, config, pkgs, osConfig, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.shell.fish;
  admin = osConfig.ooknet.host.admin;
in

{
  config = mkIf (cfg.enable || admin.shell == "fish") {
    programs.fish = {
      plugins = [
        {
          name = "done";
          src = pkgs.fishPlugins.done.src;
        }
        {
          name = "autopair";
          src = pkgs.fishPlugins.autopair.src;
        }
        {
          name = "colored-man-pages";
          src = pkgs.fishPlugins.colored-man-pages.src;
        }
      ];
    };
  };
}

