{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.ooknet.system = {
    earlyoom.enable = mkEnableOption "early OOM killer daemon";
  };
}
