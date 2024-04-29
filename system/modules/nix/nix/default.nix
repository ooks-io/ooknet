{ config, lib, inputs, ... }: 

let
  inherit (lib) mkIf;
  host = config.systemModules.host;
in

{
  config = mkIf (host.type != "phone") {
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
