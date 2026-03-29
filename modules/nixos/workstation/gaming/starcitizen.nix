{
  lib,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (config.ooknet.workstation) profiles;
in {
  imports = [
    inputs.nix-citizen.nixosModules.default
  ];
  config = mkIf (elem "gaming" profiles) {
    programs.rsi-launcher = {
      enable = false;
    };
  };
}
