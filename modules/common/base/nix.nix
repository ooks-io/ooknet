{
  inputs,
  inputs',
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (builtins) attrValues;
  inherit (lib) mapAttrs mapAttrsToList filterAttrs isType;
  inherit (config.ooknet.host) admin;
  inherit (pkgs.stdenv.hostPlatform) isLinux;

  flakeInputs = filterAttrs (_: v: isType "flake" v) inputs;

  homeDir = config.users.users.${admin.name}.home;
  paths = {
    NH_FLAKE = "${homeDir}/Summit/ookgen/ooknet";
    FLAKE = "${homeDir}/Summit/ookgen/ooknet";
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
    # FIXME: https://git.lix.systems/lix-project/lix/issues/977
    package = inputs'.nixpkgs-small.legacyPackages.lixPackageSets.stable.lix;

    optimise.automatic = true;

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
      # lix 2.95 warns on old syntax still used inside nixpkgs, not our code
      extra-deprecated-features = [
        "broken-string-indentation"
        "broken-string-escape"
        "or-as-identifier"
      ];
      accept-flake-config = false;
      warn-dirty = false;
      # cache
      builders-use-substitutes = true;
      substituters = [
        "https://cache.nixos.org"
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
  };
}
