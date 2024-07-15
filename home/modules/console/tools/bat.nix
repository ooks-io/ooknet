{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  cfg = config.ooknet.tools.bat;
in

{
  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batgrep
        prettybat
        batwatch
        batman
      ];
      config = {
        theme = "base16";
      };
    };
  };
}
