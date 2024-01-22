{ config, lib, pkgs, ... }:

with lib;

let 
  cfg = config.programs.vesktop;
  package = pkgs.vesktop;
in {

  options = {
    programs.vesktop = {
      enable = mkEnableOption
        "vesktop, a custom client for discord";

        theme = mkOption {
          type = types.str;
          default = "";
          description = "Custom css theme for vesktop";
        };

        settings = mkOption {
          type = types.attrs;
          default = {};
          description = "Vesktop settings.";
        };
    };

    config = mkIf cfg.enable {
      home.pakages = [ package ];
      xdg.configFile."vesktop/theme/custom.css".text = cfg.theme;
    };
  };
}
