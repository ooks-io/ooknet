{ osConfig, lib, ... }:

let
  inherit (lib) mkIf;
  cfg = osConfig.ooknet.programs._1password;
in

{
  config = mkIf cfg.enable {
    ooknet.binds.password = "1password";
  };
}
