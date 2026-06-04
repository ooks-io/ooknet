{
  lib,
  osConfig,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  imports = [
    inputs.nixzeroth.homeModules.nixzeroth
  ];

  config = mkIf (elem "gaming" profiles) {
    programs.nixzeroth = {
      enable = true;
      references = {
        clientsDir = "${config.home.homeDirectory}/projects/nixzeroth/.internal/reference-clients";
      };
      world = {
        enablePlayerSettings = 1;
        maxPlayerLevel = 60;
        startPlayerLevel = 60;
        rate.moveSpeed = {
          player = 1;
        };
      };
    };
  };
}
