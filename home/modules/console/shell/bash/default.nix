{ config, lib, osConfig, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.shell.bash;
  admin = osConfig.ooknet.host.admin;
in

{
  config = mkIf (cfg.enable || admin.shell == "bash") {
    programs.bash.enable = true;
  };
}
