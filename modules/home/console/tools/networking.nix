{pkgs, ...}: let
  inherit (builtins) attrValues;
in {
  home.packages = attrValues {
    inherit
      (pkgs)
      traceroute
      mtr
      dig
      nmap
      ;
  };
}
