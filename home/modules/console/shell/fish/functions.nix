{ lib, config, osConfig, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.shell.fish;
  admin = osConfig.ooknet.host.admin;
in

{
  config = mkIf (cfg.enable || admin.shell == "fish") {
    programs.fish.functions = {
      man = ''
        :q
      ''
    };
  };
}
