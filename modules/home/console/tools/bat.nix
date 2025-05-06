{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) attrValues;
  cfg = osConfig.ooknet.console.tools.bat;
in {
  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      # extraPackages = attrValues {
      #   inherit
      #     (pkgs.bat-extras)
      #     batgrep
      #     prettybat
      #     batwatch
      #     batman
      #     ;
      # };
      config = {
        # TODO: custom theme
        theme = "base16";
      };
    };
  };
}
