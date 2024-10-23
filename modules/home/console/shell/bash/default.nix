{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig.ooknet.host) admin;
  cfg = osConfig.ooknet.console.shell.bash;
in {
  config = mkIf (cfg.enable || admin.shell == "bash") {
    programs.bash.enable = true;
  };
}
