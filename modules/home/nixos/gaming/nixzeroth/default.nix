{
  lib,
  osConfig,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  imports = [
    inputs.hozen-core.homeModules.nixzeroth
  ];

  config = mkIf (elem "gaming" profiles) {
    programs.nixzeroth = {
      enable = true;
      # the cli lives in the content repo, the module has no default for it
      cli.package = inputs.nixzeroth.packages.${pkgs.system}.hozen-cli;
      references = {
        clientsDir = "${config.home.homeDirectory}/.local/share/nixzeroth/reference-clients";
      };
      # keys are the AC config names verbatim
      world = {
        EnablePlayerSettings = true;
        MaxPlayerLevel = 60;
        StartPlayerLevel = 60;
        Rate.MoveSpeed.Player = 1;
      };
    };
  };
}
