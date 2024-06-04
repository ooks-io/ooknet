{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.terminal = {
    foot.enable = mkEnableOption "";
  };
}
