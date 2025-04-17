{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) mkIf mapAttrs mapAttrsToList filterAttrs isType;
  inherit (config.ooknet.host) role admin;
  inherit (pkgs.stdenv) isLinux;

  flakeInputs = filterAttrs (_: v: isType "flake" v) inputs;

  homeDir = config.users.users.${admin.name}.home;
  paths = {
    FLAKE = "${homeDir}/Summit/ooknet";
    WEBSITE = "${paths.FLAKE}/outputs/pkgs/website";
    KUNZEN = "${homeDir}/Summit/kunzen";
  };
in {
  environment = {
    # should just move these to the flakes dedicated shell
    systemPackages = attrValues {
      inherit (pkgs) git deadnix statix;
    };

    # location of the configuration flake
    variables = paths;
  };
  nix = {
    package = pkgs.lix;

    # collect garbage
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
    # from github:fufexan
    registry = mapAttrs (_: v: {flake = v;}) flakeInputs;
    nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    settings = {
      trusted-users =
        ["root" "builder"]
        ++ (
          if isLinux
          # linux uses wheel
          then ["@wheel"]
          # macos uses admin
          else ["@admin"]
        );
      experimental-features = ["nix-command" "flakes"];
      accept-flake-config = false;
      auto-optimise-store = true;
      warn-dirty = false;
      # cache
      builders-use-substitutes = true;
      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://nix-community.cachix.org"
        "https://neovim-flake.cachix.org"
        "https://ooknet.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "neovim-flake.cachix.org-1:iyQ6lHFhnB5UkVpxhQqLJbneWBTzM8LBYOFPLNH4qZw="
        "ooknet.cachix.org-1:mtr4ue+8ux58b8mgTGRAG/txxHBnZvgX7Gi3amno+zs="
      ];
    };
  };
  nixpkgs = {
    config.allowUnfree = true;
    # why are we doing this
    overlays = mkIf (role == "workstation") [
      # zellij status bar plugin
      (_final: prev: {
        zjstatus = inputs.zjstatus.packages.${prev.system}.default;
      })
    ];
  };
}
