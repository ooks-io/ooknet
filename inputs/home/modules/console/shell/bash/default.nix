{ config, lib, ... }:
let
  cfg = config.homeModules.console.shell.bash;
in
{
  config = lib.mkIf cfg.enable {
    programs.bash.enable = true;
  };
}
