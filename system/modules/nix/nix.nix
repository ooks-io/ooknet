{ config, lib, pkgs, inputs, ... }: 

let
  cfg = config.systemModules.nixOptions;
in

{
  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        trusted-users = [ "root" "@wheel" ];
        auto-optimise-store = lib.mkDefault true;
        experimental-features = [ "nix-command" "flakes" "repl-flake" ];
        warn-dirty = false;
        system-features = [ "kvm" "big-parallel" "nixos-test" ];
        flake-registry = "";
      };
      registry = lib.mapAttrs (_: value: { flake = value; }) inputs;
      nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
    }; 
  };
}
