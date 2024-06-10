{ lib, ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.multiplexer = {
    zellij.enable = mkEnableOption "";
    tmux.enable = mkEnableOption "";
  };
}
