{ lib, config, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (builtins) elem;
  isx86Linux = pkgs: with pkgs.stdenv; hostPlatform.isLinux && hostPlatform.isx86;
  host = config.systemModules.host;
  validFunction = ["workstation" "gaming" "media-server"];
in

{
  config = mkIf (elem host.function validFunction) {
    hardware = {
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = isx86Linux pkgs;
      };
    };
  };
}
