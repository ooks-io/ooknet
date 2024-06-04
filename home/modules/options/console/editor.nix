{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.editor = {
    helix.enable = mkEnableOption "";
    nvim.enable = mkEnableOption "";
  };
}
