{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.tools = {
    kdeconnect.enable = mkEnableOption "";
  };
}
