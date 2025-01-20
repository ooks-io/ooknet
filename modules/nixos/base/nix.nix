{
  inputs',
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) mkIf mapAttrs mapAttrsToList filterAttrs isType;
  inherit (config.ooknet.host) role admin;

  flakeInputs = filterAttrs (_: v: isType "flake" v) inputs;

  paths = {
    FLAKE = "/home/${admin.name}/.config/ooknet";
    WEBSITE = "${paths.FLAKE}/outputs/pkgs/website";
  };
in {
  environment = {
    # disable default nix packages
    # these packages are installed by default [ perl rsync strace ]
    defaultPackages = [];
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
      dates = "Sun *-*-* 14:00";
      options = "--delete-older-than 14d";
    };
    # from github:fufexan
    registry = mapAttrs (_: v: {flake = v;}) flakeInputs;
    nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;
    settings = {
      trusted-users = ["@wheel" "root" "builder"];
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
    overlays = [
      # zellij status bar plugin
      (_final: prev: {
        zjstatus = inputs.zjstatus.packages.${prev.system}.default;
      })
    ];
  };

  # nix rebuild utililty
  programs.nh = mkIf (role == "workstation") {
    enable = true;
    # sets an environment variable FLAKE that nh will refer to by default
    flake = mkIf admin.homeManager "/home/${admin.name}/.config/ooknet";
  };
}
