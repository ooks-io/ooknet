{ lib, config, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.tools.bat;
in

{
  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "base16";
        pager = "less -FR";
      };
    };
  };
}
