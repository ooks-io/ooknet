{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf elem;
  inherit (builtins) attrValues;
  inherit (osConfig.ooknet.workstation) profiles;
in {
  config = mkIf (elem "gaming" profiles) {
    # disabled - openldap i686 test failure on current nixpkgs
    home.packages = attrValues {
      # inherit
      #   (pkgs)
      #   bottles
      #   ;
    };
  };
}
