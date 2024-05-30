{ config, lib, ... }:
let
  cfg = config.ooknet.console.shell.bash;
in
{
  config = lib.mkIf cfg.enable {
    programs.bash.enable = true;
  };
}
