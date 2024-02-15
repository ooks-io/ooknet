{ inputs, config, lib, ... }:

let
  cfg = config.homeModules.desktop.gaming.slippi;
in

{

imports = [
  inputs.ssbm-nix.homeManagerModule
];

  config = lib.mkIf cfg.enable {
    ssbm = {
      slippi-launcher.enable = true;
    };
  };
}
