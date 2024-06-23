{ lib, config, pkgs, ... }:

{
  home.packages = [ pkgs.xdg-utils ];
  xdg.mimeApps = {
    enable = true;
  };
}
