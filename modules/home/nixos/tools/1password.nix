{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.programs._1password;
in {
  config = mkIf cfg.enable {
    ooknet.binds = {
      password = "1password";
      quickpass = "1password --quick-access";
    };
  };
}
