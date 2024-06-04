{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.browser = {
    firefox.enable = mkEnableOption "";
    brave.enable = mkEnableOption "";
  };
}
