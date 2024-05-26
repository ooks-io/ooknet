{ lib, config, pkgs, inputs, ... }:

let
  inherit (lib) mkIf mapAttrs mapAttrsToList;
  host = config.ooknet.host;
in

{
  imports = [
    ./nh.nix
    ./nixpkgs.nix
    ./subs.nix
  ];

  config = mkIf (host.type != "phone") {
    environment = {
      systemPackages = with pkgs; [
        git
        deadnix
        statix
      ];
      defaultPackages = [];
      etc = {
        "nix/flake-channels/nixpkgs".source = inputs.nixpkgs;
        "nix/flake-channels/home-manager".source = inputs.nixpkgs;
      };
    };
    nix = {
      registry = mapAttrs (_: v: {flake = v;}) inputs;
      nixPath = mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
      optimise = {
        automatic = true;
        dates = [ "18:00" ];
      };
      gc = {
        automatic = true;
        dates = "Sun *-*-* 17:00";
        options = "--delete-older-than 30d";
      };
      settings = {
        flake-registry = "/etc/nix/registry.json";
        allowed-users = [ "root" "@wheel" ];
        trusted-users = [ "root" "@wheel" ];
        experimental-features = [ "nix-command" "flakes" ];
        builders-use-substitutes = true;
      };
    };
  };
}
