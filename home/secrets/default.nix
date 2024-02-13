{ lib, config, inputs, ... }:

let
  cfg = config.homeModules.sops;
in

{

  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];
  options.homeModules.sops.enable = lib.mkEnableOption "Enable sops";

  config = lib.mkIf cfg.enable {
    sops = {
      age.keyFile = "/home/ooks/.config/sops/age/keys.txt";
      defaultSopsFile = ./secrets.yaml;

      secrets = {
        spotifyClientId = { };
      };
    };
  };
}
