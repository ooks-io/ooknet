{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.fileManager = {
    nemo.enable = mkEnableOption "";
  };
}
