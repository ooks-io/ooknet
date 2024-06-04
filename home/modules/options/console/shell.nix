{ lib , ... }:

let
  inherit (lib) mkEnableOption;
in

{
  options.ooknet.shell = {
    fish.enable = mkEnableOption "";
    zsh.enable = mkEnableOption "";
    bash.enable = mkEnableOption "";
  };
} 
