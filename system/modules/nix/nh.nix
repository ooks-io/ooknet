{ inputs, lib, config, ... }: 

let
  cfg = config.systemModules.nixOptions;
in

{
  imports = [
    inputs.nh.nixosModules.default
  ];
  
  config = lib.mkIf cfg.enable {
    environment.variables.FLAKE = "/home/ooks/Coding/nix/ooks-io/nix";

    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 30d";
      };
    };
  };
}
