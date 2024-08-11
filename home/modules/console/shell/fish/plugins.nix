{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.ooknet.shell.fish;
  inherit (osConfig.ooknet.host) admin;
in {
  config = mkIf (cfg.enable || admin.shell == "fish") {
    programs.fish = {
      plugins = [
        {
          name = "done";
          inherit (pkgs.fishPlugins.done) src;
        }
        {
          name = "autopair";
          inherit (pkgs.fishPlugins.autopair) src;
        }
        {
          name = "colored-man-pages";
          inherit (pkgs.fishPlugins.colored-man-pages) src;
        }
      ];
    };
  };
}
